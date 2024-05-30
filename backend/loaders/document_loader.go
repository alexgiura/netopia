package loaders

import (
	"backend/db"
	_err "backend/errors"
	"backend/models"
	"backend/util"
	"context"
	"github.com/graph-gophers/dataloader"
	"log"
)

func fetchDocumentItems(ctx context.Context, dbProvider *db.Queries, keys dataloader.Keys) ([]*dataloader.Result, error) {
	ids := make([]string, len(keys))
	for i, key := range keys {
		ids[i] = key.String()
	}

	documentItems, err := fetchDocumentItemsByDocumentIds(ctx, dbProvider, ids)
	if err != nil {
		return nil, err
	}

	results := make([]*dataloader.Result, len(keys))
	for i, id := range ids {
		if items, ok := documentItems[id]; ok {
			results[i] = &dataloader.Result{Data: items} // Ensure items is a slice of DocumentItem
		} else {
			results[i] = &dataloader.Result{Data: []*models.DocumentItem{}} // Use an empty slice instead of nil
		}
	}

	return results, nil
}

func fetchDocumentItemsByDocumentIds(ctx context.Context, dbProvider *db.Queries, ids []string) (map[string][]*models.DocumentItem, error) {

	rows, err := dbProvider.GetDocumentItemsByDocumentIds(ctx, util.StrArrayToUuidArray(ids))
	if err != nil {
		log.Print("\"message\": failed to execute DBProvider.GetDocumentItemsByDocumentIds, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to load partner", "DatabaseError")
	}

	documentItems := make(map[string][]*models.DocumentItem)
	for _, row := range rows {
		documentID := row.HID.String()
		item := &models.DocumentItem{
			DId: row.DID.String(),
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
			Quantity:    row.Quantity,
			Price:       util.FloatOrNil(row.Price),
			AmountNet:   util.FloatOrNil(row.NetValue),
			AmountVat:   util.FloatOrNil(row.VatValue),
			AmountGross: util.FloatOrNil(row.GrosValue),
			ItemTypePn:  util.StringOrNil(row.ItemTypePn),
		}
		documentItems[documentID] = append(documentItems[documentID], item)
	}

	return documentItems, nil
}
