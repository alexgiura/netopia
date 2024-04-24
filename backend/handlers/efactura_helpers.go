package handlers

import (
	"backend/db"
	"backend/util"
	"context"
	"crypto/md5"
	"encoding/hex"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/google/uuid"
	pgx "github.com/jackc/pgx/v4"
	efactura "github.com/printesoi/e-factura-go"
	efactura_oauth2 "github.com/printesoi/e-factura-go/oauth2"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	xoauth2 "golang.org/x/oauth2"
)

func (r *Resolver) EfacturaProcessAuthorizationCallback(req *http.Request) error {
	var authCode *string
	authorizationID := req.URL.Query().Get("state")
	if authorizationID == "" {
		return errors.New("invalid request: state param not set")
	}

	if err := r.DBPool.BeginFunc(req.Context(), func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)

		if authErr := req.URL.Query().Get("error"); authErr != "" {
			transaction.UpdateAuthorizationStatus(req.Context(), db.UpdateAuthorizationStatusParams{
				AID:    util.StrToUUID(&authorizationID),
				Status: db.CoreEfacturaAuthorizationStatusError,
			})
		} else if code := req.URL.Query().Get("code"); code != "" {
			authCode = &code
			transaction.UpdateAuthorizationCode(req.Context(), db.UpdateAuthorizationCodeParams{
				AID:  util.StrToUUID(&authorizationID),
				Code: util.NullableStr(authCode),
			})
		}

		return nil
	}); err != nil {
		return err
	}

	if authCode != nil {
		oauth2Cfg, err := efactura_oauth2.MakeConfig(
			efactura_oauth2.ConfigCredentials(r.EfacturaSettings.ClientID, r.EfacturaSettings.ClientSecret),
			efactura_oauth2.ConfigRedirectURL(r.EfacturaSettings.CallbackURL),
		)
		if err != nil {
			return err
		}

		token, err := oauth2Cfg.Exchange(req.Context(), *authCode)
		if err != nil {
			// XXX(victor): maybe better update db status?
			return err
		}

		if err := r._EfacturaUpdateAuthorizationToken(req.Context(), util.StrToUUID(&authorizationID), token); err != nil {
			return err
		}
	}

	return nil
}

func (r *Resolver) trx(ctx context.Context, txFun func(tx *db.Queries) error) error {
	return r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)
		return txFun(transaction)
	})
}

func (r *Resolver) _EfacturaUpdateAuthorizationToken(ctx context.Context, aid uuid.UUID, token *xoauth2.Token) error {
	return r.trx(ctx, func(tx *db.Queries) error {
		return tx.UpdateAuthorizationToken(ctx, db.UpdateAuthorizationTokenParams{
			AID:            aid,
			Token:          util.MarshalToPgtypeJSON(token),
			TokenExpiresAt: util.NullableTime(&token.Expiry),
		})
	})
}

func (r *Resolver) _EfacturaGenerateDocument(ctx context.Context, documentID uuid.UUID, tx *db.Queries) (
	efacturaInvoiceXML string,
	efacturaDocID uuid.UUID,
	err error,
) {
	md5sum := func(data []byte) string {
		h := md5.New()
		h.Write(data)
		return hex.EncodeToString(h.Sum(nil))
	}

	newPartyTaxScheme := func(vatID string, setTaxScheme bool) *efactura.InvoicePartyTaxScheme {
		taxScheme := new(efactura.InvoicePartyTaxScheme)
		taxScheme.CompanyID = vatID
		if setTaxScheme {
			taxScheme.TaxScheme = efactura.TaxSchemeVAT
		}
		return taxScheme
	}

	getAddressCountrySubentity := func(countyCode string) efactura.CountrySubentityType {
		return efactura.CountrySubentityType("RO-" + strings.TrimSpace(countyCode))
	}

	getAddressCityName := func(subentityCode efactura.CountrySubentityType, locality string) string {
		if subentityCode == efactura.CountrySubentityRO_B {
			switch strings.ToLower(locality) {
			case "sector 1":
				return efactura.CityNameROBSector1
			case "sector 2":
				return efactura.CityNameROBSector2
			case "sector 3":
				return efactura.CityNameROBSector3
			case "sector 4":
				return efactura.CityNameROBSector4
			case "sector 5":
				return efactura.CityNameROBSector5
			case "sector 6":
				return efactura.CityNameROBSector6
			}
		}

		return locality
	}

	var company db.GetCompanyRow
	company, err = tx.GetCompany(ctx)
	if err != nil {
		return
	}

	var documentHeader db.GetDocumentHeaderRow
	documentHeader, err = tx.GetDocumentHeader(ctx, documentID)
	if err != nil {
		return
	}

	var documentItems []db.GetDocumentItemsRow
	documentItems, err = tx.GetDocumentItems(ctx, documentHeader.HID)
	if err != nil {
		return
	}

	partner, err := tx.GetDocumentHeaderPartnerBillingDetails(ctx, documentHeader.DocumentPartnerBillingDetailsID.Int32)
	if err != nil {
		return
	}

	// TODO: if document currency if not RON, then TaxCurrencyCode should
	// be set and use BNR currency exchange rate.
	var documentCurrencyID = efactura.CurrencyCodeType(documentHeader.Currency.String)
	if documentCurrencyID == "" {
		documentCurrencyID = efactura.CurrencyRON
	}
	if documentCurrencyID != efactura.CurrencyRON {
		err = fmt.Errorf("currency `%s` is not supported without an exchange", documentCurrencyID)
		return
	}

	number := documentHeader.Number
	if documentHeader.Series.Valid {
		number = fmt.Sprintf("%s-%s", documentHeader.Series.String, number)
	}

	invoiceBuilder := efactura.NewInvoiceBuilder(number).
		WithIssueDate(efactura.MakeDateFromTime(documentHeader.Date)).
		WithDueDate(efactura.MakeDateFromTime(documentHeader.DueDate.Time)).
		WithInvoiceTypeCode(efactura.InvoiceTypeCommercialInvoice).
		WithDocumentCurrencyCode(documentCurrencyID)

	// Supplier info
	companyVatID := company.VatNumber
	if company.Vat && !strings.HasPrefix(companyVatID, "RO") {
		companyVatID = "RO" + companyVatID
	}
	supplierAddrSubentityCode := getAddressCountrySubentity(company.CountyCode.String)
	supplierParty := efactura.InvoiceSupplierParty{
		Identifications: []efactura.InvoicePartyIdentification{{
			ID: efactura.MakeValueWithAttrs(company.VatNumber),
		}},
		CommercialName: &efactura.InvoicePartyName{
			Name: efactura.Transliterate(company.Name),
		},
		LegalEntity: efactura.InvoiceSupplierLegalEntity{
			Name:             efactura.Transliterate(company.Name),
			CompanyID:        efactura.NewValueWithAttrs(companyVatID),
			CompanyLegalForm: company.RegistrationNumber.String,
		},
		PostalAddress: efactura.MakeInvoiceSupplierPostalAddress(efactura.PostalAddress{
			Line1:            efactura.Transliterate(company.Address),
			CityName:         efactura.Transliterate(getAddressCityName(supplierAddrSubentityCode, company.Locality.String)),
			CountrySubentity: supplierAddrSubentityCode,
			Country: efactura.Country{
				Code: efactura.CountryCodeRO,
			},
		}),
	}
	// Vânzator plătitor de TVA   => BT-31
	// Vânzator neplătitor de TVA => BT-32
	vatAppliedToInvoice := true // TODO:
	if company.Vat && vatAppliedToInvoice {
		supplierParty.TaxScheme = newPartyTaxScheme(companyVatID, true)
	} else {
		supplierParty.TaxScheme = newPartyTaxScheme(companyVatID, false)
	}
	invoiceBuilder.WithSupplier(supplierParty)

	// Buyer info
	// TODO: fetch date for buyer company
	buyerVatID := partner.CorePartner.TaxID.String
	if partner.CoreDocumentPartnerBillingDetail.Vat && !strings.HasPrefix(buyerVatID, "RO") {
		buyerVatID = "RO" + buyerVatID
	}
	customerAddrSubentityCode := getAddressCountrySubentity(partner.CoreDocumentPartnerBillingDetail.CountyCode.String)
	customerParty := efactura.InvoiceCustomerParty{
		Identifications: []efactura.InvoicePartyIdentification{{
			ID: efactura.MakeValueWithAttrs(partner.CorePartner.TaxID.String),
		}},
		CommercialName: &efactura.InvoicePartyName{
			Name: efactura.Transliterate(partner.CorePartner.Name),
		},
		LegalEntity: efactura.InvoiceCustomerLegalEntity{
			Name:      efactura.Transliterate(partner.CorePartner.Name),
			CompanyID: efactura.NewValueWithAttrs(buyerVatID),
		},
		PostalAddress: efactura.MakeInvoiceCustomerPostalAddress(efactura.PostalAddress{
			Line1:            efactura.Transliterate(partner.CoreDocumentPartnerBillingDetail.Address),
			CityName:         efactura.Transliterate(getAddressCityName(customerAddrSubentityCode, partner.CoreDocumentPartnerBillingDetail.Locality.String)),
			CountrySubentity: customerAddrSubentityCode,
			Country: efactura.Country{
				Code: efactura.CountryCodeRO,
			},
		}),
	}
	// Cumpărător plătitor de TVA   => BT-48
	// Cumpărător neplătitor de TVA => BT-47
	if partner.CoreDocumentPartnerBillingDetail.Vat {
		customerParty.TaxScheme = newPartyTaxScheme(buyerVatID, false)
	} else {
		customerParty.LegalEntity.CompanyID = efactura.NewValueWithAttrs(buyerVatID)
	}
	invoiceBuilder.WithCustomer(customerParty)

	// Build invoice line items
	totalAmount := float64(0)
	for i, item := range documentItems {
		totalAmount += item.GrosValue.Float64
		var lineTaxCategory efactura.InvoiceLineTaxCategory
		if item.VatPercent > 0 {
			lineTaxCategory = efactura.InvoiceLineTaxCategory{
				TaxScheme: efactura.TaxSchemeVAT,
				ID:        efactura.TaxCategoryVATStandardRate,
				Percent:   efactura.D(item.VatPercent),
			}
		} else {
			lineTaxCategory = efactura.InvoiceLineTaxCategory{
				TaxScheme: efactura.TaxSchemeVAT,
				ID:        efactura.TaxCategoryVATZeroRate,
			}
			invoiceBuilder.AddTaxExemptionReason(efactura.TaxCategoryVATZeroRate, item.VatExemptionReason.String,
				efactura.TaxExemptionReasonCodeType(item.VatExemptionReasonCode.String))
		}
		lineBuilder := efactura.NewInvoiceLineBuilder(strconv.Itoa(i), documentCurrencyID).
			WithUnitCode(efactura.UnitCodeType(item.UmCode)).
			WithInvoicedQuantity(efactura.D(item.Quantity)).
			WithGrossPriceAmount(efactura.D(item.Price.Float64)).
			WithItemName(efactura.Transliterate(item.ItemName)).
			WithItemTaxCategory(lineTaxCategory)
		line, er := lineBuilder.Build()
		if err = er; err != nil {
			return
		}

		invoiceBuilder.AppendInvoiceLines(line)
	}

	// This needs to be set to total invoice amount for computing
	// rounding amount, otherwise total invoice amount will not match if
	// vat is computed on each item (line).
	invoiceBuilder.WithExpectedTaxInclusiveAmount(efactura.D(totalAmount))

	var efacturaInvoice efactura.Invoice
	efacturaInvoice, err = invoiceBuilder.Build()
	if err != nil {
		return
	}

	invoiceXML, err := efacturaInvoice.XMLIndent("", " ")
	if err != nil {
		return
	}

	efacturaInvoiceXML = string(invoiceXML)
	efacturaDocID, err = tx.CreateEfacturaDocument(ctx, db.CreateEfacturaDocumentParams{
		HID:           documentHeader.HID,
		InvoiceXml:    efacturaInvoiceXML,
		InvoiceMd5Sum: md5sum(invoiceXML),
	})
	if err != nil {
		return
	}

	return

}

func (r *Resolver) _EfacturaUpload(ctx context.Context, efacturaDocID uuid.UUID) (uploadIndex int64, err error) {
	var efacturaDocument db.GetEfacturaDocumentRow
	efacturaDocument, err = r.DBProvider.GetEfacturaDocument(ctx, efacturaDocID)
	if err != nil {
		return
	}
	// If status is success - the invoice was already uploaded;
	// if status is processing - it's not safe to upload until the processing is done.
	if efacturaDocument.Status == db.CoreEfacturaDocumentStatusSuccess ||
		efacturaDocument.Status == db.CoreEfacturaDocumentStatusProcessing {
		err = fmt.Errorf("not uploading e-factura document `%s`, status `%s`", efacturaDocument.EID, efacturaDocument.Status)
		return
	}

	var company db.GetCompanyRow
	company, err = r.DBProvider.GetCompany(ctx)
	if err != nil {
		return
	}

	oauth2Cfg, err := efactura_oauth2.MakeConfig(
		efactura_oauth2.ConfigCredentials(r.EfacturaSettings.ClientID, r.EfacturaSettings.ClientSecret),
		efactura_oauth2.ConfigRedirectURL(r.EfacturaSettings.CallbackURL),
	)
	if err != nil {
		r.Logger.Error("efactura_oauth2.MakeConfig failed", zap.Error(err))
		return 0, err
	}

	authorization, err := r.DBProvider.FetchLastAuthorization(ctx)
	if err != nil {
		return 0, err
	}

	token, err := efactura_oauth2.TokenFromJSON(authorization.Token.Bytes)
	if err != nil {
		r.Logger.Error("failed to parse stored token", zap.Error(err))
		return 0, err
	}

	// If the token is refreshed, update the authorization
	onTokenChanged := func(ctx context.Context, t *xoauth2.Token) error {
		r.Logger.Info("Token refreshed", zap.Field{
			Key:       "authorization_id",
			Type:      zapcore.StringType,
			Interface: authorization.AID},
		)
		return r._EfacturaUpdateAuthorizationToken(ctx, authorization.AID, t)
	}
	client, err := efactura.NewClient(
		context.Background(),
		efactura.ClientOAuth2TokenSource(oauth2Cfg.TokenSourceWithChangedHandler(ctx, token, onTokenChanged)),
		efactura.ClientProductionEnvironment(false), // TODO: use true for production
	)
	if err != nil {
		r.Logger.Error("efactura.NewClient failed", zap.Error(err))
		return 0, err
	}

	uploadRes, err := client.UploadXML(ctx, strings.NewReader(efacturaDocument.InvoiceXml),
		efactura.UploadStandardUBL, company.VatNumber)
	if err != nil {
		r.Logger.Error("client.UploadXML failed", zap.Error(err))
		return 0, err
	}
	if uploadRes.IsOk() {
		uploadIndex = uploadRes.GetUploadIndex()
		r.Logger.Info("document uploaded", zap.Field{
			Key:       "efactura_documents.id",
			Type:      zapcore.StringType,
			Interface: efacturaDocID.String(),
		}, zap.Field{
			Key:       "upload_index",
			Type:      zapcore.Int64Type,
			Interface: uploadIndex,
		})
		if err := r.trx(ctx, func(tx *db.Queries) error {
			return tx.UpdateEfacturaDocumentUploadIndex(ctx, db.UpdateEfacturaDocumentUploadIndexParams{
				EID:         efacturaDocID,
				UploadIndex: util.NullableInt64(&uploadIndex),
			})
		}); err != nil {
			r.Logger.Error("failed to store e-factura document upload index", zap.Error(err))
			return uploadIndex, err
		}
	} else {
		err := errors.New(uploadRes.GetFirstErrorMessage())
		r.Logger.Error("e-factura upload failed", zap.Error(err))
		if terr := r.trx(ctx, func(tx *db.Queries) error {
			return tx.UpdateEfacturaDocumentStatus(ctx, db.UpdateEfacturaDocumentStatusParams{
				EID:    efacturaDocID,
				Status: db.CoreEfacturaDocumentStatusError,
			})
		}); terr != nil {
			r.Logger.Error("failed to update e-factura document status", zap.Error(terr))
		}
		return 0, err
	}
	return
}

func (r *Resolver) _EfacturaGenerateAndUpload(ctx context.Context, documentID uuid.UUID, regenerate bool) (efacturaDocID uuid.UUID, uploadedIndex *int64, err error) {
	if err = r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
		transaction := r.DBProvider.WithTx(tx)

		var efacturaDocument db.GetEfacturaDocumentForHeaderIDRow
		efacturaDocument, err = transaction.GetEfacturaDocumentForHeaderID(ctx, documentID)
		if err != nil && err != pgx.ErrNoRows {
			return
		}
		// If status is success - the invoice was already uploaded;
		// if status is processing - it's not safe to upload until the processing is done.
		if efacturaDocument.Status == db.CoreEfacturaDocumentStatusSuccess ||
			efacturaDocument.Status == db.CoreEfacturaDocumentStatusProcessing {
			err = fmt.Errorf("e-factura document `%s` has status `%s`", efacturaDocument.EID, efacturaDocument.Status)
			return
		} else if efacturaDocument.Status != "" && !regenerate {
			// Don't regenerate if already generated the XML and not forcing a regeneration
			return
		}

		_, efacturaDocID, err = r._EfacturaGenerateDocument(ctx, documentID, transaction)
		return
	}); err != nil {
		r.Logger.Error("failed to generate and store E-factura XML", zap.Error(err))
		return
	}

	uid, err := r._EfacturaUpload(ctx, efacturaDocID)
	if err != nil {
		return
	}

	uploadedIndex = &uid
	return
}

func (r *Resolver) _EfacturaCheckUploadState(ctx context.Context, efacturaDocID uuid.UUID) (status db.CoreEfacturaDocumentStatus, err error) {
	var efacturaDocument db.GetEfacturaDocumentRow
	efacturaDocument, err = r.DBProvider.GetEfacturaDocument(ctx, efacturaDocID)
	if err != nil {
		return
	}
	if efacturaDocument.Status == db.CoreEfacturaDocumentStatusSuccess || efacturaDocument.Status == db.CoreEfacturaDocumentStatusError {
		status = efacturaDocument.Status
		return
	}
	if !efacturaDocument.UploadIndex.Valid {
		err = fmt.Errorf("cannot check to message state for efactura document %s, nil upload_index", efacturaDocID)
		return
	}

	oauth2Cfg, err := efactura_oauth2.MakeConfig(
		efactura_oauth2.ConfigCredentials(r.EfacturaSettings.ClientID, r.EfacturaSettings.ClientSecret),
		efactura_oauth2.ConfigRedirectURL(r.EfacturaSettings.CallbackURL),
	)
	if err != nil {
		r.Logger.Error("efactura_oauth2.MakeConfig failed", zap.Error(err))
		return
	}

	authorization, err := r.DBProvider.FetchLastAuthorization(ctx)
	if err != nil {
		return
	}

	token, err := efactura_oauth2.TokenFromJSON(authorization.Token.Bytes)
	if err != nil {
		r.Logger.Error("failed to parse stored token", zap.Error(err))
		return
	}

	// If the token is refreshed, update the authorization
	onTokenChanged := func(ctx context.Context, t *xoauth2.Token) error {
		r.Logger.Info("Token refreshed", zap.Field{
			Key:       "authorization_id",
			Type:      zapcore.StringType,
			Interface: authorization.AID},
		)
		return r._EfacturaUpdateAuthorizationToken(ctx, authorization.AID, t)
	}
	client, err := efactura.NewClient(
		context.Background(),
		efactura.ClientOAuth2TokenSource(oauth2Cfg.TokenSourceWithChangedHandler(ctx, token, onTokenChanged)),
		efactura.ClientProductionEnvironment(false), // TODO: use true for production
	)
	if err != nil {
		r.Logger.Error("efactura.NewClient failed", zap.Error(err))
		return
	}

	stateResponse, err := client.GetMessageState(ctx, efacturaDocument.UploadIndex.Int64)
	if err != nil {
		return
	}
	r.Logger.Info("message state", zap.Field{
		Key:       "efactura_documents.id",
		Type:      zapcore.StringType,
		Interface: efacturaDocID.String(),
	}, zap.Field{
		Key:       "state",
		Type:      zapcore.StringType,
		Interface: stateResponse.State,
	}, zap.Field{
		Key:       "download_id",
		Type:      zapcore.Int64Type,
		Interface: stateResponse.GetDownloadID(),
	})
	switch {
	case stateResponse.IsOk():
		status = db.CoreEfacturaDocumentStatusSuccess
		err = r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
			dbTrx := r.DBProvider.WithTx(tx)

			downloadID := stateResponse.GetDownloadID()
			_, err = dbTrx.CreateEfacturaMessage(ctx, db.CreateEfacturaMessageParams{
				EID:        efacturaDocument.EID,
				State:      db.CoreEfacturaMessageStateOk,
				DownloadID: util.NullableInt64(&downloadID),
			})
			if err != nil {
				return
			}

			err = dbTrx.UpdateEfacturaDocumentStatus(ctx, db.UpdateEfacturaDocumentStatusParams{
				EID:        efacturaDocument.EID,
				Status:     status,
				DownloadID: util.NullableInt64(&downloadID),
			})
			return
		})

	case stateResponse.IsNok():
		status = db.CoreEfacturaDocumentStatusError
		err = r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
			dbTrx := r.DBProvider.WithTx(tx)

			downloadID := stateResponse.GetDownloadID()
			errMsg := stateResponse.GetFirstErrorMessage()
			_, err = dbTrx.CreateEfacturaMessage(ctx, db.CreateEfacturaMessageParams{
				EID:          efacturaDocument.EID,
				State:        db.CoreEfacturaMessageStateNok,
				DownloadID:   util.NullableInt64(&downloadID),
				ErrorMessage: util.NullableStr(&errMsg),
			})
			if err != nil {
				return
			}

			err = dbTrx.UpdateEfacturaDocumentStatus(ctx, db.UpdateEfacturaDocumentStatusParams{
				EID:    efacturaDocument.EID,
				Status: status,
			})
			return
		})

	case stateResponse.IsInvalidXML():
		status = db.CoreEfacturaDocumentStatusError
		err = r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
			dbTrx := r.DBProvider.WithTx(tx)

			_, err = dbTrx.CreateEfacturaMessage(ctx, db.CreateEfacturaMessageParams{
				EID:   efacturaDocument.EID,
				State: db.CoreEfacturaMessageStateXmlErrors,
			})
			if err != nil {
				return
			}

			err = dbTrx.UpdateEfacturaDocumentStatus(ctx, db.UpdateEfacturaDocumentStatusParams{
				EID:    efacturaDocument.EID,
				Status: status,
			})
			return
		})

	case stateResponse.IsProcessing():
		status = db.CoreEfacturaDocumentStatusProcessing
		err = r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
			dbTrx := r.DBProvider.WithTx(tx)

			_, err = dbTrx.CreateEfacturaMessage(ctx, db.CreateEfacturaMessageParams{
				EID:   efacturaDocument.EID,
				State: db.CoreEfacturaMessageStateProcessing,
			})
			if err != nil {
				return
			}

			err = dbTrx.UpdateEfacturaDocumentStatus(ctx, db.UpdateEfacturaDocumentStatusParams{
				EID:    efacturaDocument.EID,
				Status: status,
			})
			return
		})

	default:
		err = fmt.Errorf("failed to process message state `%s`", stateResponse.State)
	}
	return
}
