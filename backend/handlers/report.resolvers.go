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
	"log"
	"time"

	pgx "github.com/jackc/pgx/v4"
)

// GetProductionNoteReport is the resolver for the getProductionNoteReport field.
func (r *queryResolver) GetProductionNoteReport(ctx context.Context, input *model.ReportInput) ([]*model.ProductionNote, error) {
	fromDate, _ := time.Parse("2006-01-02", input.StartDate)
	toDate, _ := time.Parse("2006-01-02", input.EndDate)

	rows, err := r.DBProvider.GetProductionNotesReport(ctx, db.GetProductionNotesReportParams{
		StartDate: fromDate,
		EndDate:   toDate,
		Partners:  util.StrArrayToUuidArray(input.Partners),
	})

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetProductionNotesReport, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "NoRows", "DatabaseError")
	}

	productionNoteList := make([]*model.ProductionNote, 0)
	for _, row := range rows {

		productionNote := &model.ProductionNote{
			Date:         row.Date.Format("2006-01-02"),
			PartnerName:  row.PartnerName,
			ItemName:     row.ItemName,
			ItemQuantity: row.ItemQuantity,
			RawMaterial: []float64{
				row.Quantity1,
				row.Quantity2,
				row.Quantity3,
				row.Quantity4,
				row.Quantity5,
				row.Quantity6,
			},
		}
		productionNoteList = append(productionNoteList, productionNote)
	}
	return productionNoteList, nil
}

// GetStockReport is the resolver for the getStockReport field.
func (r *queryResolver) GetStockReport(ctx context.Context, input *model.StockReportInput) ([]*model.StockReportItem, error) {
	date, _ := time.Parse("2006-01-02", *input.Date)

	rows, err := r.DBProvider.GetItemStockReport(ctx, db.GetItemStockReportParams{
		Date:             date,
		InventoryList:    util.IntArrayToInt32Array(input.InventoryList),
		ItemCategoryList: util.IntArrayToInt32Array(input.ItemCategoryList),
		ItemList:         util.StrArrayToUuidArray(input.ItemList),
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetProductionNotesReport, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "NoRows", "DatabaseError")
	}

	stockReportItems := make([]*model.StockReportItem, 0)

	for _, row := range rows {
		itemCode := row.ItemCode
		itemUm := row.ItemUm
		stockReportItem := &model.StockReportItem{

			ItemCode:     &itemCode,
			ItemName:     row.ItemName,
			ItemUm:       &itemUm,
			ItemQuantity: row.ItemQuantity,
		}

		stockReportItems = append(stockReportItems, stockReportItem)

	}
	return stockReportItems, nil
}

// GetTransactionAvailableItems is the resolver for the getTransactionAvailableItems field.
func (r *queryResolver) GetTransactionAvailableItems(ctx context.Context, input *model.TransactionAvailableItemsInput) ([]*model.GenerateAvailableItems, error) {
	//date, err := time.Parse("2006-01-02", input.Date)
	rows, err := r.DBProvider.GetTransactionAvailableItems(ctx, db.GetTransactionAvailableItemsParams{
		InputPartners:      util.StrArrayToUuidArray(input.Partners),
		InputTransactionID: int32(input.TransactionID),
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetTransactionAvailableItems, "+"\"error\": ", err.Error())
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

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type queryResolver struct{ *Resolver }
