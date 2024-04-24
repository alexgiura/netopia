package handlers

import (
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

func (r *Resolver) GetDocumentItems(ctx context.Context, transaction *db.Queries, orderID uuid.UUID) ([]*model.DocumentItem, error) {
	rows, err := transaction.GetDocumentItems(ctx, orderID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		r.Logger.Error("failed to execute DBProvider.GetDocumentItems", zap.Error(err))
		return nil, _err.Error(ctx, "Failed to get document items", "DatabaseError")
	}

	items := make([]*model.DocumentItem, 0)

	// Iterate through GetOrderDetails results
	for _, row := range rows {
		dId := row.DID.String()

		item := &model.DocumentItem{
			DID:      &dId,
			ItemID:   row.ItemID.String(),
			ItemCode: util.StringOrNil(row.ItemCode),
			ItemName: row.ItemName,
			Quantity: row.Quantity,
			Um: &model.Um{
				ID:   int(row.UmID),
				Name: row.UmName,
				Code: row.UmCode,
			},
			Price: util.FloatOrNil(row.Price),
			Vat: &model.Vat{
				ID:                  int(row.VatID),
				Name:                row.VatName,
				Percent:             row.VatPercent,
				ExemptionReason:     util.StringOrNil(row.VatExemptionReason),
				ExemptionReasonCode: util.StringOrNil(row.VatExemptionReasonCode),
			},
			AmountNet:   util.FloatOrNil(row.NetValue),
			AmountVat:   util.FloatOrNil(row.VatValue),
			AmountGross: util.FloatOrNil(row.GrosValue),
			ItemTypePn:  util.StringOrNil(row.ItemTypePn),
		}

		items = append(items, item)
	}
	return items, nil
}

func (r *Resolver) _SaveDocument(ctx context.Context, transaction *db.Queries, input model.DocumentInput) (*model.Document, error) {

	newDocument := &model.Document{}

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
		return nil, err
	}
	newDocument = document

	// If is PN then create CN and RN
	if input.DocumentType == 8 {
		var cnErr, rnErr error

		cnErr = r._CreateCN(ctx, transaction, *newDocument)
		if cnErr != nil {
			return nil, cnErr
		}

		rnErr = r._CreateRN(ctx, transaction, *newDocument)
		if rnErr != nil {
			return nil, rnErr
		}

	}

	// Check for auto generate Production Note
	if newDocument.Type.ID == 4 {

		for _, item := range newDocument.DocumentItems {

			// get item type
			itemCategory, err := transaction.GetItemCategoryByID(ctx, util.StrToUUID(&item.ItemID))

			if errors.Is(err, pgx.ErrNoRows) {

			} else if err != nil {

				log.Print("\"message\":Failed to execute transaction.GetItemCategoryByID "+"\"error\": ", err.Error())
				return nil, _err.Error(ctx, "Failed to get item category", "DatabaseError")
			} else {

				if itemCategory.GeneratePn == true {

					err := r._CreatePN(ctx, transaction, *newDocument, *item)
					if err != nil {
						return nil, err
					}

				}
			}

		}
	}

	return newDocument, nil

}

func (r *Resolver) _GetDocumentByID(ctx context.Context, transaction *db.Queries, documentID *string) (*model.Document, error) {
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

	// get Document Partner
	documentPartner, err := transaction.GetDocumentHeaderPartner(ctx, row.PartnerID)
	if err != nil {
		log.Print("\"message\":Failed to execute DBProvider.GetDocumentHeaderPartner "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get document partner", "DatabaseError")

	}

	// get Document Items
	docItems, err := r.GetDocumentItems(ctx, transaction, docId)
	if err != nil {

		return nil, err
	}

	return &model.Document{
		HID: row.HID.String(),
		Type: &model.DocumentType{
			ID:     *util.IntOrNil(row.DocumentTypeID),
			NameRo: *util.StringOrNil(row.DocumentTypeNameRo),
			NameEn: *util.StringOrNil(row.DocumentTypeNameEn),
		},
		Series: util.StringOrNil(row.Series),
		Number: row.Number,
		Date:   row.Date.Format("2006-01-02"),

		Partner: &model.Partner{
			ID:            documentPartner.ID.String(),
			Code:          util.StringOrNil(documentPartner.Code),
			Name:          documentPartner.Name,
			Type:          documentPartner.Type,
			TaxID:         util.StringOrNil(documentPartner.TaxID),
			CompanyNumber: util.StringOrNil(documentPartner.CompanyNumber),
			PersonalID:    util.StringOrNil(documentPartner.PersonalID),
			IsActive:      documentPartner.IsActive,
		},
		PersonID:      util.NullUuidToString(row.PersonID),
		PersonName:    util.StringOrNil(row.PersonName),
		Notes:         util.StringOrNil(row.Notes),
		IsDeleted:     row.IsDeleted,
		DocumentItems: docItems,
	}, nil
}

func (r *Resolver) _CreateCN(ctx context.Context, transaction *db.Queries, input model.Document) error {

	//Create a new input
	newInputCN := model.DocumentInput{}

	// Filter the DocumentItemInput list based on a condition
	var filteredItems []*model.DocumentItemInput

	for index, item := range input.DocumentItems {
		generatedDId := make([]string, 0)
		if item.ItemTypePn != nil && *item.ItemTypePn == model.ProductionItemTypeRawMaterial.String() {
			generatedDId = append(generatedDId, *input.DocumentItems[index].DID)
			filteredItems = append(filteredItems, &model.DocumentItemInput{
				ItemID:       item.ItemID,
				Quantity:     item.Quantity,
				Price:        item.Price,
				AmountNet:    item.AmountNet,
				AmountVat:    item.AmountVat,
				AmountGross:  item.AmountGross,
				GeneratedDID: generatedDId,
			})

		}

	}

	// Assign the new values to newInput
	newInputCN.Date = input.Date
	newInputCN.PartnerID = input.Partner.ID
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

func (r *Resolver) _CreateRN(ctx context.Context, transaction *db.Queries, input model.Document) error {
	//Create a new input
	newInputRN := model.DocumentInput{}

	// Filter the DocumentItemInput list based on a condition
	var filteredItems []*model.DocumentItemInput

	for index, item := range input.DocumentItems {
		generatedDId := make([]string, 0)
		if item.ItemTypePn != nil && *item.ItemTypePn == model.ProductionItemTypeFinalProduct.String() {
			generatedDId = append(generatedDId, *input.DocumentItems[index].DID)
			filteredItems = append(filteredItems, &model.DocumentItemInput{
				ItemID:       item.ItemID,
				Quantity:     item.Quantity,
				Price:        item.Price,
				AmountNet:    item.AmountNet,
				AmountVat:    item.AmountVat,
				AmountGross:  item.AmountGross,
				GeneratedDID: generatedDId,
			})

		}

	}

	// Assign the new values to newInput
	newInputRN.Date = input.Date
	newInputRN.PartnerID = input.Partner.ID
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
func (r *Resolver) _CreatePN(ctx context.Context, transaction *db.Queries, input model.Document, item model.DocumentItem) error {
	//Create a new input
	newInputPN := model.DocumentInput{}

	rows, err := transaction.GetRecipeByItemId(ctx, util.StrToUUID(&item.ItemID))
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
				if recipeItem.ItemID == item.ItemID {
					generatedDId = append(generatedDId, *item.DID)
				}

				// Convert into decimal for  decimal accuracy
				totalQuantity := decimal.NewFromFloat(recipeItem.Quantity).Mul(decimal.NewFromFloat(item.Quantity))

				documentItemInput := &model.DocumentItemInput{
					ItemID:       recipeItem.ItemID,
					Quantity:     totalQuantity.InexactFloat64(),
					ItemTypePn:   recipeItem.ItemTypePn,
					GeneratedDID: generatedDId,
				}

				// Append the new DocumentItemInput to the list
				documentItemsInput = append(documentItemsInput, documentItemInput)
			}

			newInputPN.Date = input.Date
			newInputPN.PartnerID = input.Partner.ID
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

func (r *Resolver) _RegeneratePN(ctx context.Context, transaction *db.Queries, docId uuid.UUID) error {
	// Get new created document
	hIdStr := docId.String()
	document, err := r._GetDocumentByID(ctx, transaction, &hIdStr)
	if err != nil {
		return err
	}
	newDocument := document

	if newDocument.Type.ID == 4 {

		for _, item := range newDocument.DocumentItems {

			// get item type
			itemCategory, err := transaction.GetItemCategoryByID(ctx, util.StrToUUID(&item.ItemID))

			if errors.Is(err, pgx.ErrNoRows) {

			} else if err != nil {

				log.Print("\"message\":Failed to execute transaction.GetItemCategoryByID "+"\"error\": ", err.Error())
				return _err.Error(ctx, "Failed to get item category", "DatabaseError")
			} else {

				if itemCategory.GeneratePn == true {

					err := r._CreatePN(ctx, transaction, *newDocument, *item)
					if err != nil {
						return err
					}

				}
			}

		}
	}
	return nil

}
