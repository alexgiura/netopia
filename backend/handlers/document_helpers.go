package handlers

import (
	"backend/models"
	"context"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/pkg/errors"
	"github.com/shopspring/decimal"
	"go.uber.org/zap"

	"backend/db"
	_err "backend/errors"
	"backend/graph/model"
	"backend/util"
)

func (r *Resolver) _SaveDocument(ctx context.Context, transaction *db.Queries, input model.DocumentInput) (*models.Document, error) {

	newDocument := &models.Document{}
	var newDocumentItems []*models.DocumentItem

	// Save document header
	date, err := time.Parse("2006-01-02", input.Date)
	hId, err := transaction.SaveDocument(ctx, db.SaveDocumentParams{

		DocumentType:     int32(input.DocumentType),
		Series:           util.ParamStr(input.Series),
		Number:           input.Number,
		PartnerID:        util.StrToUUID(&input.PartnerID),
		Date:             date,
		RepresentativeID: util.NullableUuid(util.StrToUUID(input.PersonID)),
		RecipeID:         util.NullableInt32(input.RecipeID),
		Notes:            util.NullableStr(input.Notes),
		CurrencyID:       util.NullableInt32(input.CurrencyID),
	})
	if err != nil {
		r.Logger.Error("failed to save document header", zap.Error(err))
		return nil, err
	}

	if len(input.DocumentItems) > 0 {

		for _, item := range input.DocumentItems {

			dId, err := transaction.SaveDocumentDetails(ctx, db.SaveDocumentDetailsParams{
				HID:        hId,
				ItemID:     util.StrToUUID(&item.ItemID),
				Quantity:   item.Quantity,
				Price:      util.NullableFloat64(item.Price),
				NetValue:   util.NullableFloat64(item.AmountNet),
				VatValue:   util.NullableFloat64(item.AmountVat),
				GrossValue: util.NullableFloat64(item.AmountGross),
				ItemTypePn: util.NullableStr(item.ItemTypePn),
			})

			if err != nil {
				r.Logger.Error("failed to save document details", zap.Error(err))
				return nil, err
			}
			// Check for d_ids
			if item.GeneratedDID != nil {
				itemQuantity := item.Quantity
				for _, generatedDId := range item.GeneratedDID {

					//select quantity of that dId
					documentDetails, err := transaction.GetDocumentDetails(ctx, util.StrToUUID(&generatedDId))
					if err != nil {
						r.Logger.Error("failed to get d_id", zap.Error(err))
						return nil, err
					} else {
						// check for TransactionId
						idTransaction := 0
						if input.TransactionID != nil {
							idTransaction = *input.TransactionID
						}
						if itemQuantity > documentDetails.Quantity {
							err := transaction.SaveDocumentConnection(ctx, db.SaveDocumentConnectionParams{

								TransactionID: int32(idTransaction),
								HID:           hId,
								DID:           dId,
								HIDSource:     documentDetails.HID,
								DIDSource:     documentDetails.DID,
								ItemID:        util.StrToUUID(&item.ItemID),
								Quantity:      documentDetails.Quantity,
							})
							if err != nil {
								r.Logger.Error("failed to save document connection", zap.Error(err))
								return nil, err
							}
							itemQuantity -= documentDetails.Quantity
						} else if itemQuantity <= documentDetails.Quantity {
							err := transaction.SaveDocumentConnection(ctx, db.SaveDocumentConnectionParams{
								TransactionID: int32(idTransaction),
								HID:           hId,
								DID:           dId,
								HIDSource:     documentDetails.HID,
								DIDSource:     documentDetails.DID,
								ItemID:        util.StrToUUID(&item.ItemID),
								Quantity:      itemQuantity,
							})
							if err != nil {
								r.Logger.Error("failed to save document connection", zap.Error(err))
								return nil, err
							}
							itemQuantity = 0
							break
						}

					}

				}

			}

		}
	}

	// Get new created document
	hIdStr := hId.String()
	document, err2 := r._GetDocumentByID(ctx, transaction, &hIdStr)
	if err2 != nil {
		return nil, err2
	}
	documentItems, err3 := r._GetDocumentItemsById(ctx, transaction, &hIdStr)
	if err3 != nil {
		return nil, err3
	}
	newDocument = document
	newDocumentItems = documentItems

	// If is PN then create CN and RN
	if input.DocumentType == 8 {
		var cnErr, rnErr error

		cnErr = r._CreateCN(ctx, transaction, *newDocument, newDocumentItems, input.PartnerID)
		if cnErr != nil {
			return nil, cnErr
		}

		rnErr = r._CreateRN(ctx, transaction, *newDocument, newDocumentItems, input.PartnerID)
		if rnErr != nil {
			return nil, rnErr
		}

	}

	// Check for auto generate Production Note
	if newDocument.Type.ID == 4 {

		for _, documentItem := range newDocumentItems {

			// get item type
			itemCategory, err := transaction.GetItemCategoryByID(ctx, util.StrToUUID(&documentItem.Item.ID))

			if errors.Is(err, pgx.ErrNoRows) {

			} else if err != nil {

				log.Print("\"message\":Failed to execute transaction.GetItemCategoryByID "+"\"error\": ", err.Error())
				return nil, _err.Error(ctx, "Failed to get item category", "DatabaseError")
			} else {

				if itemCategory.GeneratePn == true {

					err := r._CreatePN(ctx, transaction, *newDocument, *documentItem, input.PartnerID)
					if err != nil {
						return nil, err
					}

				}
			}

		}
	}

	return newDocument, nil

}

func (r *Resolver) _GetDocumentByID(ctx context.Context, transaction *db.Queries, documentID *string) (*models.Document, error) {
	docId := util.StrToUUID(documentID)

	// get Document Header
	row, err := transaction.GetDocumentHeader(ctx, docId)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, _err.Error(ctx, "ErrNoRows", "DatabaseError")
		}
		log.Print("\"message\":Failed to execute DBProvider.GetDocumentHeader "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get document", "DatabaseError")

	}
	efacturaStatus := string(row.EfacturaStatus.CoreEfacturaDocumentStatus)
	return &models.Document{
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
	}, nil
}
func (r *Resolver) _GetDocumentItemsById(ctx context.Context, transaction *db.Queries, documentID *string) ([]*models.DocumentItem, error) {
	docId := util.StrToUUID(documentID)
	rows, err := transaction.GetDocumentItems(ctx, docId)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		r.Logger.Error("failed to execute DBProvider.GetDocumentItems", zap.Error(err))
		return nil, _err.Error(ctx, "Failed to get document items", "DatabaseError")
	}

	items := make([]*models.DocumentItem, 0)

	// Iterate through GetOrderDetails results
	for _, row := range rows {
		dId := row.DID.String()

		item := &models.DocumentItem{
			DId: dId,
			Item: models.Item{
				ID:   row.ItemID.String(),
				Code: util.StringOrNil(row.ItemCode),
				Name: row.ItemName,
				Um: models.Um{
					ID:   int(row.UmID),
					Name: row.UmName,
					Code: row.UmCode,
				},
				Vat: models.Vat{
					ID:                  int(row.VatID),
					Name:                row.VatName,
					Percent:             row.VatPercent,
					ExemptionReason:     util.StringOrNil(row.VatExemptionReason),
					ExemptionReasonCode: util.StringOrNil(row.VatExemptionReasonCode),
				},
			},

			Quantity: row.Quantity,

			Price: util.FloatOrNil(row.Price),

			AmountNet:   util.FloatOrNil(row.NetValue),
			AmountVat:   util.FloatOrNil(row.VatValue),
			AmountGross: util.FloatOrNil(row.GrosValue),
			ItemTypePn:  util.StringOrNil(row.ItemTypePn),
		}

		items = append(items, item)
	}
	return items, nil
}

func (r *Resolver) _CreateCN(ctx context.Context, transaction *db.Queries, input models.Document, documentItems []*models.DocumentItem, partnerId string) error {

	//Create a new input
	newInputCN := model.DocumentInput{}

	// Filter the DocumentItemInput list based on a condition
	var filteredItems []*model.DocumentItemInput

	for index, documentItem := range documentItems {
		generatedDId := make([]string, 0)
		if documentItem.ItemTypePn != nil && *documentItem.ItemTypePn == model.ProductionItemTypeRawMaterial.String() {
			generatedDId = append(generatedDId, documentItems[index].DId)
			filteredItems = append(filteredItems, &model.DocumentItemInput{
				ItemID:       documentItem.Item.ID,
				Quantity:     documentItem.Quantity,
				Price:        documentItem.Price,
				AmountNet:    documentItem.AmountNet,
				AmountVat:    documentItem.AmountVat,
				AmountGross:  documentItem.AmountGross,
				GeneratedDID: generatedDId,
			})

		}

	}

	// Assign the new values to newInput
	newInputCN.Date = input.Date
	newInputCN.PartnerID = partnerId
	newInputCN.DocumentItems = filteredItems
	newInputCN.DocumentType = 6
	newInputCN.Number = "BC-" + input.Number
	newNotes := "Generated from RP-" + input.Number
	newInputCN.Notes = &newNotes
	newTransactionID := 3
	newInputCN.TransactionID = &newTransactionID

	// Save newInput

	_, err := r._SaveDocument(ctx, transaction, newInputCN)
	if err != nil {
		r.Logger.Error("failed to save document connection", zap.Error(err))
		return err
	}

	return nil

}

func (r *Resolver) _CreateRN(ctx context.Context, transaction *db.Queries, input models.Document, documentItems []*models.DocumentItem, partnerId string) error {
	//Create a new input
	newInputRN := model.DocumentInput{}

	// Filter the DocumentItemInput list based on a condition
	var filteredItems []*model.DocumentItemInput

	for index, documentItem := range documentItems {
		generatedDId := make([]string, 0)
		if documentItem.ItemTypePn != nil && *documentItem.ItemTypePn == model.ProductionItemTypeFinalProduct.String() {
			generatedDId = append(generatedDId, documentItems[index].DId)
			filteredItems = append(filteredItems, &model.DocumentItemInput{
				ItemID:       documentItem.Item.ID,
				Quantity:     documentItem.Quantity,
				Price:        documentItem.Price,
				AmountNet:    documentItem.AmountNet,
				AmountVat:    documentItem.AmountVat,
				AmountGross:  documentItem.AmountGross,
				GeneratedDID: generatedDId,
			})

		}

	}

	// Assign the new values to newInput
	newInputRN.Date = input.Date
	newInputRN.PartnerID = partnerId
	newInputRN.DocumentItems = filteredItems
	newInputRN.DocumentType = 7
	newInputRN.Number = "NP-" + input.Number
	newNotes := "Generated from RP-" + input.Number
	newInputRN.Notes = &newNotes
	newTransactionID := 4
	newInputRN.TransactionID = &newTransactionID
	// Save newInput
	_, err := r._SaveDocument(ctx, transaction, newInputRN)
	if err != nil {
		r.Logger.Error("failed to save document connection", zap.Error(err))
		return err
	}
	return nil
}
func (r *Resolver) _CreatePN(ctx context.Context, transaction *db.Queries, input models.Document, documentItem models.DocumentItem, partnerId string) error {
	//Create a new input
	newInputPN := model.DocumentInput{}

	rows, err := transaction.GetRecipeByItemId(ctx, util.StrToUUID(&documentItem.Item.ID))
	if err != nil {
		log.Print("\"message\":Failed to execute transaction.GetRecipeByItemId "+"\"error\": ", err.Error())
		return _err.Error(ctx, "Failed to get item recipe", "DatabaseError")
	} else {
		if len(rows) > 1 {
			return _err.Error(ctx, "MultipleRecipe", "MultipleRecipe")
		} else if len(rows) == 0 {
			return _err.Error(ctx, "NoRecipe", "NoRecipe")
		} else {

			// Create document items from recipe items
			recipeItems, err := r._getRecipeItems(ctx, transaction, rows[0].ID)
			if err != nil {
				return err
			}

			documentItemsInput := make([]*model.DocumentItemInput, 0)
			for _, recipeItem := range recipeItems {

				generatedDId := make([]string, 0)
				if recipeItem.Item.ID == documentItem.Item.ID {
					generatedDId = append(generatedDId, documentItem.DId)
				}

				// Convert into decimal for  decimal accuracy
				totalQuantity := decimal.NewFromFloat(recipeItem.Quantity).Mul(decimal.NewFromFloat(documentItem.Quantity))

				documentItemInput := &model.DocumentItemInput{
					ItemID:       recipeItem.Item.ID,
					Quantity:     totalQuantity.InexactFloat64(),
					ItemTypePn:   recipeItem.ItemTypePn,
					GeneratedDID: generatedDId,
				}

				// Append the new DocumentItemInput to the list
				documentItemsInput = append(documentItemsInput, documentItemInput)
			}

			newInputPN.Date = input.Date
			newInputPN.PartnerID = partnerId
			newInputPN.DocumentItems = documentItemsInput
			newInputPN.DocumentType = 8
			newInputPN.Number = "RP-" + input.Number
			newNotes := "Generated from AC-" + input.Number
			newInputPN.Notes = &newNotes
			newTransactionID := 5
			newInputPN.TransactionID = &newTransactionID

			// Save newInput
			_, errSave := r._SaveDocument(ctx, transaction, newInputPN)
			if errSave != nil {
				return err
			}
		}

	}

	return nil

}
func (r *Resolver) _GetGeneratedDocuments(ctx context.Context, docId uuid.UUID) ([]*model.GeneratedDocument, error) {
	generatedDocs, err := r.DBProvider.GetGeneratedDocuments(ctx, docId)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.GetGeneratedDocuments "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get generated docs", "DatabaseError")
	}
	generatedDocuments := make([]*model.GeneratedDocument, 0)
	if len(generatedDocs) > 0 {
		for _, doc := range generatedDocs {
			generatedDocument := &model.GeneratedDocument{
				DocumentType:         doc.DocumentType,
				Number:               doc.DocumentNumber,
				DocumentSourceNumber: doc.DocumentSourceNumber,
			}
			generatedDocuments = append(generatedDocuments, generatedDocument)
			// Recursively call _GetGeneratedDocuments for the current document
			subGeneratedDocuments, err := r._GetGeneratedDocuments(ctx, doc.HID)
			if err != nil {
				return nil, err
			}

			// Append the subGeneratedDocuments to the main slice
			generatedDocuments = append(generatedDocuments, subGeneratedDocuments...)
		}
	}
	return generatedDocuments, nil
}

func (r *Resolver) _CancelGeneratedDocuments(ctx context.Context, transaction *db.Queries, docId uuid.UUID) error {
	generatedDocs, err := r.DBProvider.GetGeneratedDocuments(ctx, docId)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.GetGeneratedDocuments "+"\"error\": ", err.Error())
		return _err.Error(ctx, "Failed to get generated docs", "DatabaseError")
	}

	if len(generatedDocs) > 0 {
		for _, doc := range generatedDocs {

			// Recursively call _CancelGeneratedDocuments for the current document
			err := r._CancelGeneratedDocuments(ctx, transaction, doc.HID)
			if err != nil {
				return err
			}

			// Cancel Document
			err = r._DeleteDocument(ctx, transaction, doc.HID)
			if err != nil {
				return err
			}

		}
	}

	return nil
}

func (r *Resolver) _CancelGeneratedDocumentsNoInvoices(ctx context.Context, transaction *db.Queries, docId uuid.UUID) error {
	generatedDocs, err := r.DBProvider.GetGeneratedDocuments(ctx, docId)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.GetGeneratedDocuments "+"\"error\": ", err.Error())
		return _err.Error(ctx, "Failed to get generated docs", "DatabaseError")
	}

	if len(generatedDocs) > 0 {
		for _, doc := range generatedDocs {

			// Recursively call _CancelGeneratedDocuments for the current document
			err := r._CancelGeneratedDocuments(ctx, transaction, doc.HID)
			if err != nil {
				return err
			}

			// Cancel Document
			if doc.DocumentType == "Bon Consum" || doc.DocumentType == "Nota Predare" || doc.DocumentType == "Raport Productie" {
				err = r._DeleteDocument(ctx, transaction, doc.HID)
				if err != nil {
					return err
				}
			}

		}
	}

	return nil
}

func (r *Resolver) _DeleteDocument(ctx context.Context, transaction *db.Queries, docId uuid.UUID) error {

	// Delete document
	err := transaction.DeleteDocument(ctx, docId)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.DeleteDocument "+"\"error\": ", err.Error())
		return _err.Error(ctx, "Failed to delete document", "DatabaseError")
	}

	// Remove document connections
	err = transaction.RemoveDocumentConnections(ctx, docId)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.RemoveDocumentConnections "+"\"error\": ", err.Error())
		return _err.Error(ctx, "Failed to delete document", "DatabaseError")
	}

	return nil

}

//func (r *Resolver) _RegeneratePN(ctx context.Context, transaction *db.Queries, docId uuid.UUID) error {
//	// Get new created document
//	hIdStr := docId.String()
//	document, err := r._GetDocumentByID(ctx, transaction, &hIdStr)
//	if err != nil {
//		return err
//	}
//	newDocument := document
//
//	if newDocument.Type.ID == 4 {
//
//		for _, documentItem := range newDocument.DocumentItems {
//
//			// get item type
//			itemCategory, err := transaction.GetItemCategoryByID(ctx, util.StrToUUID(&documentItem.Item.ID))
//
//			if errors.Is(err, pgx.ErrNoRows) {
//
//			} else if err != nil {
//
//				log.Print("\"message\":Failed to execute transaction.GetItemCategoryByID "+"\"error\": ", err.Error())
//				return _err.Error(ctx, "Failed to get item category", "DatabaseError")
//			} else {
//
//				if itemCategory.GeneratePn == true {
//
//					err := r._CreatePN(ctx, transaction, *newDocument, *documentItem)
//					if err != nil {
//						return err
//					}
//
//				}
//			}
//
//		}
//	}
//	return nil
//
//}
