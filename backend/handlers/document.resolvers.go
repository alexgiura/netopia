package handlers

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.44

import (
	"backend/db"
	_err "backend/errors"
	"backend/graph/generated"
	"backend/graph/model"
	"backend/models"
	"backend/util"
	"context"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/graph-gophers/dataloader"
	pgx "github.com/jackc/pgx/v4"
)

// Partner is the resolver for the partner field.
func (r *documentResolver) Partner(ctx context.Context, obj *models.Document) (*models.Partner, error) {
	loaders, ok := ctx.Value("loaders").(*models.Loaders)
	if !ok {
		log.Print("\"message\": Unable to fetch loaders from context, \"error\": context value is not of type *models.Loaders")
		return nil, _err.Error(ctx, "ContextError", "InternalError")
	}

	result, err := loaders.PartnerLoader.Load(ctx, dataloader.StringKey(obj.HId))()
	if err != nil {
		log.Print("\"message\": Failed to load partner using PartnerLoader, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "FailedToLoadPartner", "DatabaseError")
	}

	partner, ok := result.(*models.Partner)
	if !ok {
		log.Print("\"message\": Unexpected type for Partner, \"error\": unexpected type ", fmt.Sprintf("%T", result))
		return nil, _err.Error(ctx, "UnexpectedType", "InternalError")
	}

	return partner, nil
}

// Currency is the resolver for the currency field.
func (r *documentResolver) Currency(ctx context.Context, obj *models.Document) (*models.Currency, error) {
	loaders, ok := ctx.Value("loaders").(*models.Loaders)
	if !ok {
		log.Print("\"message\": Unable to fetch loaders from context, \"error\": context value is not of type *models.Loaders")
		return nil, _err.Error(ctx, "ContextError", "InternalError")
	}

	result, err := loaders.CurrencyLoader.Load(ctx, dataloader.StringKey(obj.HId))()
	if err != nil {
		log.Print("\"message\": Failed to load currency using CurrencyLoader, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "FailedToLoadCurrency", "DatabaseError")
	}

	// Handle case where result is nil
	if result == nil {
		return nil, nil
	}

	currency, ok := result.(*models.Currency)
	if !ok {
		log.Print("\"message\": Unexpected type for Currency, \"error\": unexpected type ", fmt.Sprintf("%T", result))
		return nil, _err.Error(ctx, "UnexpectedType", "InternalError")
	}

	return currency, nil
}

// DocumentItems is the resolver for the document_items field.
func (r *documentResolver) DocumentItems(ctx context.Context, obj *models.Document) ([]*models.DocumentItem, error) {
	loaders, ok := ctx.Value("loaders").(*models.Loaders)
	if !ok {
		log.Print("\"message\": Unable to fetch loaders from context, \"error\": context value is not of type *models.Loaders")
		return nil, _err.Error(ctx, "ContextError", "InternalError")
	}

	resultFuture := loaders.DocumentItemLoader.Load(ctx, dataloader.StringKey(obj.HId))
	result, err := resultFuture()
	if err != nil {
		log.Print("\"message\": Failed to load document items using DocumentItemLoader, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "FailedToLoadDocumentItems", "DatabaseError")
	}

	documentItems, ok := result.([]*models.DocumentItem)
	if !ok {
		log.Print("\"message\": Unexpected type for DocumentItems, \"error\": unexpected type ", fmt.Sprintf("%T", result))
		return nil, _err.Error(ctx, "UnexpectedType", "InternalError")
	}

	return documentItems, nil
}

// SaveDocument is the resolver for the saveDocument field.
func (r *mutationResolver) SaveDocument(ctx context.Context, input model.DocumentInput) (*models.Document, error) {
	var document *models.Document

	if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)

		var err error
		document, err = r._SaveDocument(ctx, transaction, input)
		if err != nil {
			return err
		}

		return nil
	}); err != nil {
		return nil, err
	}

	return document, nil
}

// DeleteDocument is the resolver for the deleteDocument field.
func (r *mutationResolver) DeleteDocument(ctx context.Context, input model.DeleteDocumentInput) (*string, error) {
	hIdUuid := util.StrToUUID(&input.HID)
	generatedDocuments, err := r._GetGeneratedDocuments(ctx, hIdUuid)
	if err != nil {
		return nil, err
	}
	if len(generatedDocuments) == 0 {

		if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
			transaction := r.DBProvider.WithTx(tx)

			// Delete document without generated documents
			err := r._DeleteDocument(ctx, transaction, hIdUuid)
			if err != nil {
				return err
			}

			return nil
		}); err != nil {
			return nil, err
		}

	} else {
		if input.DeleteGenerated == true {

			if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
				transaction := r.DBProvider.WithTx(tx)

				// Cancel generated docs
				err := r._CancelGeneratedDocuments(ctx, transaction, hIdUuid)
				if err != nil {
					return err
				}

				// Delete document
				err = r._DeleteDocument(ctx, transaction, hIdUuid)
				if err != nil {
					return err
				}

				return nil
			}); err != nil {
				return nil, err
			}

		} else {

			// Create a formatted message with multiple lines
			message := "Exista documente generate:\n"
			for _, data := range generatedDocuments {
				message += fmt.Sprintf("%s: %s\n", data.DocumentType, data.Number)
			}

			return nil, _err.Error(ctx, message, "GeneratedDocumentsExist")
		}

	}
	response := "success"
	return &response, nil
}

// GeneratePNAllDoc is the resolver for the generatePNAllDoc field.
func (r *mutationResolver) GeneratePNAllDoc(ctx context.Context, start *bool) (*string, error) {
	panic(fmt.Errorf("not implemented: GeneratePNAllDoc - generatePNAllDoc"))
}

// RegenerateProductionNotes is the resolver for the regenerateProductionNotes field.
func (r *mutationResolver) RegenerateProductionNotes(ctx context.Context, input model.GetDocumentsInput) (*string, error) {
	//startDate, _ := time.Parse("2006-01-02", input.StartDate)
	//endDate, _ := time.Parse("2006-01-02", input.EndDate)
	//
	//if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
	//	transaction := r.DBProvider.WithTx(tx)
	//
	//	rows, err := transaction.GetDocuments(ctx, db.GetDocumentsParams{
	//		DocumentType: int32(input.DocumentType),
	//		StartDate:    startDate,
	//		EndDate:      endDate,
	//		Partner:      util.StrArrayToUuidArray(input.Partner),
	//	})
	//
	//	if err != nil {
	//		if errors.Is(err, pgx.ErrNoRows) {
	//			return nil
	//		}
	//		log.Print("\"message\":Failed to execute DBProvider.GetDocuments, "+"\"error\": ", err.Error())
	//		return _err.Error(ctx, "Failed to get documents", "DatabaseError")
	//	}
	//	for _, document := range rows {
	//		// Cancel generated docs
	//		err := r._CancelGeneratedDocumentsNoInvoices(ctx, transaction, document.HID)
	//		if err != nil {
	//			return err
	//		}
	//
	//		err2 := r._RegeneratePN(ctx, transaction, document.HID,input.Partner)
	//		if err2 != nil {
	//			return err2
	//		}
	//	}
	//
	//	return nil
	//}); err != nil {
	//	return nil, err
	//}
	//var returnStr = "success"
	//return &returnStr, nil
	return nil, nil
}

// GetDocuments is the resolver for the getDocuments field.
func (r *queryResolver) GetDocuments(ctx context.Context, input model.GetDocumentsInput) ([]*models.Document, error) {
	startDate, _ := time.Parse("2006-01-02", input.StartDate)
	endDate, _ := time.Parse("2006-01-02", input.EndDate)

	rows, err := r.DBProvider.GetDocuments(ctx, db.GetDocumentsParams{
		DocumentType: int32(input.DocumentType),
		StartDate:    startDate,
		EndDate:      endDate,
		Partner:      util.StrArrayToUuidArray(input.Partner),
	})

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetDocuments, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get documents", "DatabaseError")
	}

	documents := make([]*models.Document, 0)

	for _, row := range rows {
		efacturaStatus := string(row.EfacturaStatus.CoreEfacturaDocumentStatus)
		document := &models.Document{
			HId: row.HID.String(),
			Type: models.DocumentType{
				ID:     *util.IntOrNil(row.DocumentTypeID),
				NameRo: *util.StringOrNil(row.DocumentTypeNameRo),
				NameEn: *util.StringOrNil(row.DocumentTypeNameEn),
			},
			Series:  util.StringOrNil(row.Series),
			Number:  row.Number,
			Date:    row.Date.Format("2006-01-02"),
			Notes:   util.StringOrNil(row.Notes),
			Deleted: row.IsDeleted,
			EFactura: &models.EFactura{
				Status:       &efacturaStatus,
				ErrorMessage: util.StringOrNil(row.EfacturaErrorMessage),
			},
		}

		documents = append(documents, document)
	}
	return documents, nil
}

// GetDocumentByID is the resolver for the getDocumentById field.
func (r *queryResolver) GetDocumentByID(ctx context.Context, documentID *string) (*models.Document, error) {
	var returnDoc *models.Document
	if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)
		document, err := r._GetDocumentByID(ctx, transaction, documentID)
		if err != nil {
			return err
		}

		returnDoc = document
		return nil
	}); err != nil {

		return nil, err
	}

	return returnDoc, nil
}

// GetDocumentTransactions is the resolver for the getDocumentTransactions field.
func (r *queryResolver) GetDocumentTransactions(ctx context.Context) ([]*model.DocumentTransaction, error) {
	rows, err := r.DBProvider.GetDocumentTransactions(ctx)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetDocumentTransactions, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "InvalidDocumentTransaction", "DatabaseError")
	}
	transactions := make([]*model.DocumentTransaction, 0)
	for _, row := range rows {

		transaction := &model.DocumentTransaction{
			ID:                        int(row.ID),
			Name:                      row.Name,
			DocumentTypeSourceID:      int(row.DocumentTypeSourceID),
			DocumentTypeDestinationID: int(row.DocumentTypeDestinationID),
		}

		transactions = append(transactions, transaction)
	}
	return transactions, nil
}

// GetGenerateAvailableItems is the resolver for the getGenerateAvailableItems field.
func (r *queryResolver) GetGenerateAvailableItems(ctx context.Context, input model.GetGenerateAvailableItemsInput) ([]*model.GenerateAvailableItems, error) {
	date, err := time.Parse("2006-01-02", input.Date)
	rows, err := r.DBProvider.GetGenerateAvailableItems(ctx, db.GetGenerateAvailableItemsParams{
		Partners:      util.StrToUUID(&input.PartnerID),
		Date:          date,
		TransactionID: int32(input.TransactionID),
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetGenerateAvailableItems, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "NoRows", "DatabaseError")
	}

	items := make([]*model.GenerateAvailableItems, 0)
	for _, row := range rows {
		dId := row.DID.String()
		item := &model.GenerateAvailableItems{
			HID:    row.HID.String(),
			Number: row.Number,
			Date:   row.Date.Format("2006-01-02"),
			DocumentItem: &models.DocumentItem{
				DId: dId,
				Item: models.Item{
					ID:   row.ItemID.String(),
					Code: &row.ItemCode,
					Name: row.ItemName,
					Um: models.Um{
						ID:   int(row.UmID),
						Name: row.UmName,
					},
					Vat: models.Vat{
						ID:      int(row.VatID),
						Name:    row.VatName,
						Percent: row.VatPercent,
					},
				},
				Quantity: row.Quantity,
			},
		}

		items = append(items, item)
	}
	return items, nil
}

// GetCurrencyList is the resolver for the getCurrencyList field.
func (r *queryResolver) GetCurrencyList(ctx context.Context) ([]*models.Currency, error) {
	rows, err := r.DBProvider.GetCurrencyList(ctx)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.GetDocumentCurrency, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get currency list", "DatabaseError")
	}
	currencyList := make([]*models.Currency, 0)
	for _, row := range rows {
		currency := &models.Currency{
			ID:        int(row.ID),
			Name:      row.Name,
			IsPrimary: row.IsPrimary,
		}

		currencyList = append(currencyList, currency)
	}
	return currencyList, nil
}

// Document returns generated.DocumentResolver implementation.
func (r *Resolver) Document() generated.DocumentResolver { return &documentResolver{r} }

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

type documentResolver struct{ *Resolver }
type mutationResolver struct{ *Resolver }
