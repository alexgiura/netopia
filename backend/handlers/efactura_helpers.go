package handlers

import (
	"backend/db"
	"backend/util"
	"context"
	"crypto/md5"
	"database/sql"
	"encoding/hex"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/google/uuid"
	pgx "github.com/jackc/pgx/v4"
	efactura "github.com/printesoi/e-factura-go/efactura"
	efactura_oauth2 "github.com/printesoi/e-factura-go/oauth2"
	efactura_text "github.com/printesoi/e-factura-go/text"
	"go.uber.org/zap"
	xoauth2 "golang.org/x/oauth2"
)

// EfacturaProcessAuthorizationCallback process a request sent to the e-factura
// authorization callback endpoint. If the request has an `error` param, the
// authorization failed, otherwise the request should have a `code` param which
// represents the authorization code that must be exchanged to a token. The
// callback request must have the `code` param, which represents the UUID of
// the e-factura authorization.
func (r *Resolver) EfacturaProcessAuthorizationCallback(req *http.Request) (authorizationStatus db.CoreEfacturaAuthorizationStatus, err error) {
	var authCode string
	authorizationID := req.URL.Query().Get("state")
	if authorizationID == "" {
		err = errors.New("e-factura: authorization: invalid request: state param not set")
		return
	}

	if err = r.DBPool.BeginFunc(req.Context(), func(tx pgx.Tx) (err error) {
		transaction := r.DBProvider.WithTx(tx)

		if authErr := req.URL.Query().Get("error"); authErr != "" {
			authorizationStatus = db.CoreEfacturaAuthorizationStatusError
			err = transaction.UpdateAuthorizationStatus(req.Context(), db.UpdateAuthorizationStatusParams{
				AID:    util.StrToUUID(&authorizationID),
				Status: db.CoreEfacturaAuthorizationStatusError,
			})
		} else if authCode = req.URL.Query().Get("code"); authCode != "" {
			authorizationStatus = db.CoreEfacturaAuthorizationStatusError
			err = transaction.UpdateAuthorizationCode(req.Context(), db.UpdateAuthorizationCodeParams{
				AID:  util.StrToUUID(&authorizationID),
				Code: util.NullableStr(&authCode),
			})
		}
		return
	}); err != nil {
		err = fmt.Errorf("e-factura: authorization: update failed: %w", err)
		return
	}

	if authCode != "" {
		var oauth2Cfg efactura_oauth2.Config
		oauth2Cfg, err = efactura_oauth2.MakeConfig(
			efactura_oauth2.ConfigCredentials(r.EfacturaSettings.ClientID, r.EfacturaSettings.ClientSecret),
			efactura_oauth2.ConfigRedirectURL(r.EfacturaSettings.CallbackURL),
		)
		if err != nil {
			err = fmt.Errorf("e-factura: authorization: create oauth2 config failed: %w", err)
			return
		}

		var token *xoauth2.Token
		token, err = oauth2Cfg.Exchange(req.Context(), authCode)
		if err != nil {
			// XXX(victor): maybe better update db status?
			err = fmt.Errorf("e-factura: authorization: oauth2 exchange code failed: %w", err)
			return
		}

		authorizationStatus = db.CoreEfacturaAuthorizationStatusSuccess
		if err = r._EfacturaUpdateAuthorizationToken(req.Context(), util.StrToUUID(&authorizationID), token); err != nil {
			err = fmt.Errorf("e-factura: authorization: update token failed: %w", err)
			return
		}
	}

	return
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

// _EfacturaGenerateXMLDocument generates the XML invoice for e-factura and stores in the efactura_xml_documents table.
// NOTE: this method does not check if we can / are allowed to generate the record.
func (r *Resolver) _EfacturaGenerateXMLDocument(ctx context.Context, documentID uuid.UUID, tx *db.Queries) (
	efacturaInvoiceXML string,
	xmlDocID int64,
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
		err = fmt.Errorf("e-factura: generate: fetch company failed: %w", err)
		return
	}

	var documentHeader db.GetDocumentHeaderRow
	documentHeader, err = tx.GetDocumentHeader(ctx, documentID)
	if err != nil {
		err = fmt.Errorf("e-factura: generate: fetch document header failed: %w", err)
		return
	}

	var partnerBillingDetails struct {
		Name       string
		VatNumber  string
		Vat        bool
		Address    string
		Locality   string
		CountyCode string
	}
	if documentHeader.DocumentPartnerBillingDetailsID.Valid {
		partner, perr := tx.GetDocumentHeaderPartnerBillingDetails(ctx, documentHeader.DocumentPartnerBillingDetailsID.Int32)
		if perr != nil {
			err = fmt.Errorf("e-factura: generate: fetch document partner billing details failed: %w", perr)
			return
		}

		partnerBillingDetails.Name = partner.CorePartner.Name
		partnerBillingDetails.VatNumber = partner.CorePartner.VatNumber.String
		partnerBillingDetails.Address = partner.CoreDocumentPartnerBillingDetail.Address
		partnerBillingDetails.Locality = partner.CoreDocumentPartnerBillingDetail.Locality.String
		partnerBillingDetails.CountyCode = partner.CoreDocumentPartnerBillingDetail.CountyCode.String
	} else {
		partner, perr := tx.GetDocumentHeaderPartner(ctx, documentHeader.PartnerID)
		if err != nil {
			err = fmt.Errorf("e-factura: generate: fetch document partner failed: %w", perr)
			return
		}

		partnerBillingDetails.Name = partner.Name
		partnerBillingDetails.VatNumber = partner.VatNumber.String
		partnerBillingDetails.Vat = partner.Vat
		partnerBillingDetails.Address = partner.Address.String
		partnerBillingDetails.Locality = partner.Locality.String
		partnerBillingDetails.CountyCode = partner.CountyCode.String
	}

	if partnerBillingDetails.Name == "" || partnerBillingDetails.VatNumber == "" ||
		partnerBillingDetails.Address == "" || partnerBillingDetails.Locality == "" ||
		partnerBillingDetails.CountyCode == "" {
		err = fmt.Errorf("e-factura: generate: invalid partner billing details")
		return
	}

	var documentItems []db.GetDocumentItemsRow
	documentItems, err = tx.GetDocumentItems(ctx, documentHeader.HID)
	if err != nil {
		err = fmt.Errorf("e-factura: generate: fetch document items failed: %w", err)
		return
	}

	var documentCurrencyID = efactura.CurrencyCodeType(documentHeader.Currency.String)
	if documentCurrencyID == "" {
		documentCurrencyID = efactura.CurrencyRON
	}
	// TODO: if document currency if not RON, then TaxCurrencyCode should
	// be set and use BNR currency exchange rate.
	if documentCurrencyID != efactura.CurrencyRON {
		err = fmt.Errorf("e-factura: generate: currency `%s` is not supported without an exchange rate", documentCurrencyID)
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

	// Build invoice line items
	totalAmount := float64(0)
	for i, item := range documentItems {
		totalAmount += item.GrosValue.Float64
		var lineTaxCategory efactura.InvoiceLineTaxCategory
		if !company.Vat {
			if item.VatValue.Float64 != 0 {
				err = fmt.Errorf("e-factura: generate: item=%s: company is not VAT enabled but item has VAT amount", item.DID)
				return
			}
			lineTaxCategory = efactura.InvoiceLineTaxCategory{
				TaxScheme: efactura.TaxSchemeVAT,
				ID:        efactura.TaxCategoryNotSubjectToVAT,
			}
			invoiceBuilder.AddTaxExemptionReason(efactura.TaxCategoryNotSubjectToVAT, "", efactura.TaxExemptionCodeVATEX_EU_O)
		} else if item.VatValue.Float64 != 0 {
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
			WithItemName(efactura_text.Transliterate(item.ItemName)).
			WithItemTaxCategory(lineTaxCategory)
		line, er := lineBuilder.Build()
		if err = er; err != nil {
			err = fmt.Errorf("e-factura: generate: item=%s: build line failed: %w", item.DID, err)
			return
		}

		invoiceBuilder.AppendInvoiceLines(line)
	}

	// This needs to be set to total invoice amount for computing
	// rounding amount, otherwise total invoice amount will not match if
	// vat is computed on each item (line).
	invoiceBuilder.WithExpectedTaxInclusiveAmount(efactura.D(totalAmount))

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
			Name: efactura_text.Transliterate(company.Name),
		},
		LegalEntity: efactura.InvoiceSupplierLegalEntity{
			Name:             efactura_text.Transliterate(company.Name),
			CompanyID:        efactura.NewValueWithAttrs(companyVatID),
			CompanyLegalForm: company.RegistrationNumber.String,
		},
		PostalAddress: efactura.MakeInvoiceSupplierPostalAddress(efactura.PostalAddress{
			Line1:            efactura_text.Transliterate(company.Address),
			CityName:         efactura_text.Transliterate(getAddressCityName(supplierAddrSubentityCode, company.Locality.String)),
			CountrySubentity: supplierAddrSubentityCode,
			Country: efactura.Country{
				Code: efactura.CountryCodeRO,
			},
		}),
	}
	// Vânzator plătitor de TVA   => BT-31
	// Vânzator neplătitor de TVA => BT-32
	if company.Vat {
		supplierParty.TaxScheme = newPartyTaxScheme(companyVatID, true)
	} else {
		supplierParty.TaxScheme = newPartyTaxScheme(companyVatID, false)
	}
	invoiceBuilder.WithSupplier(supplierParty)

	// Buyer info
	buyerVatID := partnerBillingDetails.VatNumber
	if partnerBillingDetails.Vat && !strings.HasPrefix(buyerVatID, "RO") {
		buyerVatID = "RO" + buyerVatID
	}
	customerAddrSubentityCode := getAddressCountrySubentity(partnerBillingDetails.CountyCode)
	customerParty := efactura.InvoiceCustomerParty{
		Identifications: []efactura.InvoicePartyIdentification{{
			ID: efactura.MakeValueWithAttrs(partnerBillingDetails.VatNumber),
		}},
		CommercialName: &efactura.InvoicePartyName{
			Name: efactura_text.Transliterate(partnerBillingDetails.Name),
		},
		LegalEntity: efactura.InvoiceCustomerLegalEntity{
			Name:      efactura_text.Transliterate(partnerBillingDetails.Name),
			CompanyID: efactura.NewValueWithAttrs(buyerVatID),
		},
		PostalAddress: efactura.MakeInvoiceCustomerPostalAddress(efactura.PostalAddress{
			Line1:            efactura_text.Transliterate(partnerBillingDetails.Address),
			CityName:         efactura_text.Transliterate(getAddressCityName(customerAddrSubentityCode, partnerBillingDetails.Locality)),
			CountrySubentity: customerAddrSubentityCode,
			Country: efactura.Country{
				Code: efactura.CountryCodeRO,
			},
		}),
	}
	// Cumpărător plătitor de TVA   => BT-48
	// Cumpărător neplătitor de TVA => BT-47
	if partnerBillingDetails.Vat {
		customerParty.TaxScheme = newPartyTaxScheme(buyerVatID, false)
	} else {
		customerParty.LegalEntity.CompanyID = efactura.NewValueWithAttrs(buyerVatID)
	}
	invoiceBuilder.WithCustomer(customerParty)

	var efacturaInvoice efactura.Invoice
	efacturaInvoice, err = invoiceBuilder.Build()
	if err != nil {
		err = fmt.Errorf("e-factura: generate: build invoice object failed: %w", err)
		return
	}

	invoiceXML, err := efacturaInvoice.XMLIndent("", " ")
	if err != nil {
		err = fmt.Errorf("e-factura: generate: generate invoice XML failed: %w", err)
		return
	}

	efacturaInvoiceXML = string(invoiceXML)
	xmlDocID, err = tx.CreateEfacturaXMLDocument(ctx, db.CreateEfacturaXMLDocumentParams{
		HID:           documentHeader.HID,
		InvoiceXml:    efacturaInvoiceXML,
		InvoiceMd5Sum: md5sum(invoiceXML),
	})
	if err != nil {
		err = fmt.Errorf("e-factura: generate: create xml document failed: %w", err)
	}
	return
}

// _EfacturaGenerateDocument generates a record in the efactura_documents table
// for a given document header ID, check if generation is allowed and logs the error if any.
// Returns the uuid of the record from the efactura_documents table. If regenerate is false
// and a record already exists, this returns the UUID of the existing record and no error.
// If regenerate is true and we are not allowed to regenerate the XML (an upload is in progress,
// the invoice is uploaded but still processing, or already processed) then an error is returned.
func (r *Resolver) _EfacturaGenerateDocumentCheck(ctx context.Context, documentID uuid.UUID, regenerate bool) (
	efacturaDocID uuid.UUID,
	err error,
) {
	if err = r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
		transaction := r.DBProvider.WithTx(tx)

		var efacturaDocument db.GetEfacturaDocumentForHeaderIDLockForUpdateRow
		efacturaDocument, err = transaction.GetEfacturaDocumentForHeaderIDLockForUpdate(ctx, documentID)
		if err != nil && err != pgx.ErrNoRows {
			err = fmt.Errorf("e-factura: generate: fetch document failed: %w", err)
			return
		}
		switch efacturaDocument.Status {
		case db.CoreEfacturaDocumentStatusSuccess, db.CoreEfacturaDocumentStatusProcessing:
			efacturaDocID = efacturaDocument.EID
			// If status is success - the invoice was already uploaded;
			// if status is processing - it's not safe to upload until the processing is done.
			if regenerate {
				err = fmt.Errorf("e-factura: generate: document has status `%s`", efacturaDocument.Status)
				return
			}
		case db.CoreEfacturaDocumentStatusNew:
			efacturaDocID = efacturaDocument.EID
			if regenerate && efacturaDocument.UploadRecordID.Valid {
				err = fmt.Errorf("e-factura: generate: not generating: upload in progress")
				return
			}
		}
		if efacturaDocument.Status != "" && !regenerate {
			// Don't regenerate if already generated the XML and not forcing a regeneration
			efacturaDocID = efacturaDocument.EID
			return
		}

		_, xmlDocID, err := r._EfacturaGenerateXMLDocument(ctx, documentID, transaction)
		if err != nil {
			return err
		}

		if (uuid.UUID{}) == efacturaDocument.EID {
			efacturaDocID, err = transaction.CreateEfacturaDocument(ctx, db.CreateEfacturaDocumentParams{
				HID:    documentID,
				XID:    xmlDocID,
				Status: db.CoreEfacturaDocumentStatusNew,
			})
			if err != nil {
				err = fmt.Errorf("e-factura: generate: insert failed: %w", err)
				return
			}
		} else {
			efacturaDocID = efacturaDocument.EID
			err = transaction.UpdateEfacturaDocumentXMLDocumentID(ctx, db.UpdateEfacturaDocumentXMLDocumentIDParams{
				EID: efacturaDocument.EID,
				XID: xmlDocID,
			})
			if err != nil {
				err = fmt.Errorf("e-factura: generate: update failed: %w", err)
				return
			}
		}

		return
	}); err != nil {
		fields := []zap.Field{
			zap.Error(err),
			zap.String("document_headers.h_id", documentID.String()),
		}
		if (uuid.UUID{}) != efacturaDocID {
			fields = append(fields, zap.String("efactura_documents.e_id", efacturaDocID.String()))
		}
		r.Logger.Error("e-factura: generate failed", fields...)
		return
	}
	return
}

func (r *Resolver) _EfacturaOnTokenChangedFunc(authorizationID uuid.UUID) func(ctx context.Context, t *xoauth2.Token) error {
	return func(ctx context.Context, t *xoauth2.Token) error {
		r.Logger.Info("e-factura: token refreshed", zap.String("efactura_authorizations.a_id", authorizationID.String()), zap.Time("expires_at", t.Expiry))
		return r.trx(ctx, func(tx *db.Queries) (err error) {
			_, err = tx.CloneAuthorizationWithToken(ctx, db.CloneAuthorizationWithTokenParams{
				AID:            authorizationID,
				Token:          util.MarshalToPgtypeJSON(t),
				TokenExpiresAt: util.NullableTime(&t.Expiry),
			})
			return
		})
	}
}

// _EfacturaUpload upload the e-factura document given by e_id to e-factura
// system. This method DOES NOT update the status of the e-factura document.
func (r *Resolver) _EfacturaUpload(ctx context.Context, efacturaDocument db.GetEfacturaDocumentLockForUpdateRow) (uploadIndex int64, err error) {
	var company db.GetCompanyRow
	company, err = r.DBProvider.GetCompany(ctx)
	if err != nil {
		err = fmt.Errorf("e-factura: upload: fetch company failed: %w", err)
		return
	}

	oauth2Cfg, err := efactura_oauth2.MakeConfig(
		efactura_oauth2.ConfigCredentials(r.EfacturaSettings.ClientID, r.EfacturaSettings.ClientSecret),
		efactura_oauth2.ConfigRedirectURL(r.EfacturaSettings.CallbackURL),
	)
	if err != nil {
		err = fmt.Errorf("e-factura: upload: create config failed: %w", err)
		return
	}

	authorization, err := r.DBProvider.FetchLastAuthorization(ctx)
	if err != nil {
		err = fmt.Errorf("e-factura: upload: fetch authorization failed: %w", err)
		return
	}

	// We don't check the authorization expires_at because even if the access
	// token is expired, the refresh can be still valid, so we will first
	// (automatically) try to refresh it and only fail if refresh did not
	// succeed.
	token, err := efactura_oauth2.TokenFromJSON(authorization.Token.Bytes)
	if err != nil {
		err = fmt.Errorf("e-factura: upload: parse token failed: %w", err)
		return
	}

	// If the token is refreshed, update the authorization
	// TODO: use efactura.NewProductionClient for production
	client, err := efactura.NewSandboxClient(ctx,
		oauth2Cfg.TokenSourceWithChangedHandler(ctx, token, r._EfacturaOnTokenChangedFunc(authorization.AID)))
	if err != nil {
		err = fmt.Errorf("e-factura: upload: create client failed: %w", err)
		return
	}

	uploadRes, err := client.UploadXML(ctx, strings.NewReader(efacturaDocument.InvoiceXml),
		efactura.UploadStandardUBL, company.VatNumber)
	if err != nil {
		err = fmt.Errorf("e-factura: upload: upload invoice API call failed: %w", err)
		return
	}
	if uploadRes.IsOk() {
		uploadIndex = uploadRes.GetUploadIndex()
	} else {
		err = fmt.Errorf("e-factura: upload: upload failed: error message: %s", uploadRes.GetFirstErrorMessage())
		return
	}
	return
}

// _EfacturaUploadUpdateStatus same as _EfacturaUpload but also update the
// e-factura document status on success or on error.
func (r *Resolver) _EfacturaUploadUpdateStatus(ctx context.Context, efacturaDocID uuid.UUID) (uploadIndex int64, err error) {
	var efacturaDocument db.GetEfacturaDocumentLockForUpdateRow
	var uploadRecordID int64

	if err = r.trx(ctx, func(tx *db.Queries) (err error) {
		efacturaDocument, err = r.DBProvider.GetEfacturaDocumentLockForUpdate(ctx, efacturaDocID)
		if err != nil {
			err = fmt.Errorf("e-factura: upload: fetch record failed: %w", err)
			return
		}
		switch efacturaDocument.Status {
		case db.CoreEfacturaDocumentStatusSuccess, db.CoreEfacturaDocumentStatusProcessing:
			// If status is success - the invoice was already uploaded;
			// if status is processing - it's not safe to upload until the processing is done.
			err = fmt.Errorf("e-factura: upload: not uploading: status=`%s`", efacturaDocument.Status)
			return
		case db.CoreEfacturaDocumentStatusNew:
			if efacturaDocument.UploadRecordID.Valid {
				err = fmt.Errorf("e-factura: upload: not uploading: upload in progress")
				return
			}
		}

		uploadRecordID, err = tx.CreateEfacturaDocumentUpload(ctx, db.CreateEfacturaDocumentUploadParams{
			EID:    efacturaDocID,
			XID:    efacturaDocument.XID,
			Status: db.CoreEfacturaDocumentStatusNew,
		})
		if err != nil {
			err = fmt.Errorf("e-factura: upload: store record failed: %w", err)
			return
		}
		return nil
	}); err != nil {
		r.Logger.Error("e-factura: store upload failed",
			zap.Error(err),
			zap.String("efactura_documents.id", efacturaDocID.String()))
		return
	}

	uploadIndex, err = r._EfacturaUpload(ctx, efacturaDocument)
	if err != nil {
		r.Logger.Error("e-factura: upload failed",
			zap.Error(err),
			zap.String("efactura_documents.id", efacturaDocID.String()))
		if terr := r.trx(ctx, func(tx *db.Queries) error {
			return tx.UpdateEfacturaUploadStatus(ctx, db.UpdateEfacturaUploadStatusParams{
				ID:     uploadRecordID,
				Status: db.CoreEfacturaDocumentStatusError,
			})
		}); terr != nil {
			// Return the error from _EfacturaUpload instead of returning the
			// update status error, but log the latter.
			r.Logger.Error("e-factura: update document status failed",
				zap.Error(terr),
				zap.String("efactura_documents.id", efacturaDocID.String()))
		}
	} else {
		r.Logger.Info("e-factura: invoice uploaded",
			zap.String("efactura_documents.id", efacturaDocID.String()),
			zap.Int64("upload_index", uploadIndex))
		if err = r.trx(ctx, func(tx *db.Queries) error {
			return tx.UpdateEfacturaUploadIndex(ctx, db.UpdateEfacturaUploadIndexParams{
				ID:          uploadRecordID,
				UploadIndex: util.NullableInt64(&uploadIndex),
			})
		}); err != nil {
			r.Logger.Error("e-factura: update document upload index failed",
				zap.Error(err),
				zap.String("efactura_documents.id", efacturaDocID.String()))
			err = fmt.Errorf("e-factura: upload: efactura.document=%s: update failed: %w", efacturaDocID, err)
			return
		}
	}
	return
}

// _EfacturaGenerateAndUpload will generate if needed the efactura_documents
// record for a given document header ID and will upload it to the e-factura
// system.
func (r *Resolver) _EfacturaGenerateAndUpload(ctx context.Context, documentID uuid.UUID, regenerate bool) (efacturaDocID uuid.UUID, uploadedIndex *int64, err error) {
	efacturaDocID, err = r._EfacturaGenerateDocumentCheck(ctx, documentID, regenerate)
	if err != nil {
		// Don't log the error, the _EfacturaGenerateDocumentCheck should do this.
		return
	}

	uid, err := r._EfacturaUploadUpdateStatus(ctx, efacturaDocID)
	if err != nil {
		// Don't log the error, the _EfacturaUploadUpdateStatus should do this.
		return
	}

	uploadedIndex = &uid
	return
}

func (r *Resolver) _EfacturaCheckUploadState(ctx context.Context, efacturaDocID uuid.UUID) (status db.CoreEfacturaDocumentStatus, err error) {
	logError := func(err error) {
		r.Logger.Error("e-factura: check upload state failed", zap.Error(err), zap.String("efactura_documents.eid", efacturaDocID.String()))
	}
	var efacturaDocument db.GetEfacturaDocumentRow
	efacturaDocument, err = r.DBProvider.GetEfacturaDocument(ctx, efacturaDocID)
	if err != nil {
		err = fmt.Errorf("e-factura: check: fetch record failed: %w", err)
		logError(err)
		return
	}
	if efacturaDocument.Status == db.CoreEfacturaDocumentStatusSuccess || efacturaDocument.Status == db.CoreEfacturaDocumentStatusError {
		status = efacturaDocument.Status
		return
	}
	if !efacturaDocument.UploadIndex.Valid || !efacturaDocument.UploadRecordID.Valid {
		err = fmt.Errorf("e-factura: check: nil upload index")
		logError(err)
		return
	}

	oauth2Cfg, err := efactura_oauth2.MakeConfig(
		efactura_oauth2.ConfigCredentials(r.EfacturaSettings.ClientID, r.EfacturaSettings.ClientSecret),
		efactura_oauth2.ConfigRedirectURL(r.EfacturaSettings.CallbackURL),
	)
	if err != nil {
		err = fmt.Errorf("e-factura: check: create oauth2 config failed: %w", err)
		logError(err)
		return
	}

	authorization, err := r.DBProvider.FetchLastAuthorization(ctx)
	if err != nil {
		err = fmt.Errorf("e-factura: check: fetch authorization failed: %w", err)
		logError(err)
		return
	}

	token, err := efactura_oauth2.TokenFromJSON(authorization.Token.Bytes)
	if err != nil {
		err = fmt.Errorf("e-factura: check: parse token failed: %w", err)
		logError(err)
		return
	}

	// If the token is refreshed, update the authorization
	// TODO: use efactura.NewProductionClient for production
	client, err := efactura.NewSandboxClient(ctx,
		oauth2Cfg.TokenSourceWithChangedHandler(ctx, token, r._EfacturaOnTokenChangedFunc(authorization.AID)))
	if err != nil {
		err = fmt.Errorf("e-factura: upload: create client failed: %w", err)
		logError(err)
		return
	}

	stateResponse, err := client.GetMessageState(ctx, efacturaDocument.UploadIndex.Int64)
	if err != nil {
		err = fmt.Errorf("e-factura: check: get message state API call failed: %w", err)
		logError(err)
		return
	}

	fields := []zap.Field{
		zap.String("efactura_documents.id", efacturaDocID.String()),
		zap.String("state", string(stateResponse.State)),
	}
	downloadID := stateResponse.GetDownloadID()
	if downloadID != 0 {
		fields = append(fields, zap.Int64("download_id", downloadID))
	}
	firstErrorMessage := stateResponse.GetFirstErrorMessage()
	if firstErrorMessage != "" {
		fields = append(fields, zap.String("first_error_message", stateResponse.GetFirstErrorMessage()))
	}
	r.Logger.Info("e-factura: check message state", fields...)

	updateStatus := func(messageState db.CoreEfacturaMessageState, documentStatus db.CoreEfacturaDocumentStatus,
		downloadID int64, errorMessage string) error {
		var dbDownloadID sql.NullInt64
		if downloadID != 0 {
			dbDownloadID = util.NullableInt64(&downloadID)
		}
		var dbErrorMessage sql.NullString
		if errorMessage != "" {
			dbErrorMessage = util.NullableStr(&errorMessage)
		}

		return r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) (err error) {
			dbTrx := r.DBProvider.WithTx(tx)

			_, err = dbTrx.CreateEfacturaMessage(ctx, db.CreateEfacturaMessageParams{
				UID:          efacturaDocument.UploadRecordID.Int64,
				State:        messageState,
				DownloadID:   dbDownloadID,
				ErrorMessage: dbErrorMessage,
			})
			if err != nil {
				return
			}
			err = dbTrx.UpdateEfacturaUploadStatus(ctx, db.UpdateEfacturaUploadStatusParams{
				ID:         efacturaDocument.UploadRecordID.Int64,
				Status:     status,
				DownloadID: dbDownloadID,
			})
			return
		})
	}

	switch {
	case stateResponse.IsOk():
		status = db.CoreEfacturaDocumentStatusSuccess
		err = updateStatus(db.CoreEfacturaMessageStateOk, status, downloadID, firstErrorMessage)

	case stateResponse.IsNok():
		status = db.CoreEfacturaDocumentStatusError
		err = updateStatus(db.CoreEfacturaMessageStateNok, status, downloadID, firstErrorMessage)

	case stateResponse.IsInvalidXML():
		status = db.CoreEfacturaDocumentStatusError
		err = updateStatus(db.CoreEfacturaMessageStateXmlErrors, status, downloadID, firstErrorMessage)

	case stateResponse.IsProcessing():
		status = db.CoreEfacturaDocumentStatusProcessing
		err = updateStatus(db.CoreEfacturaMessageStateProcessing, status, downloadID, firstErrorMessage)

	default:
		err = fmt.Errorf("e-factura: check: unknown message state: %s", stateResponse.State)
	}

	if err != nil {
		err = fmt.Errorf("e-factura: check: update record failed: %w", err)
		logError(err)
	}
	return
}
