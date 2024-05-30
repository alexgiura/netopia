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

func fetchRecipeItems(ctx context.Context, dbProvider *db.Queries, keys dataloader.Keys) ([]*dataloader.Result, error) {
	ids := make([]string, len(keys))
	for i, key := range keys {
		ids[i] = key.String()
	}

	documentItems, err := fetchDocumentItemsByRecipeIds(ctx, dbProvider, ids)
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

func fetchDocumentItemsByRecipeIds(ctx context.Context, dbProvider *db.Queries, ids []string) (map[string][]*models.DocumentItem, error) {

	idList, _ := util.StringArrayToInt32Array(ids)

	rows, err := dbProvider.GetRecipeItemsByDocumentIds(ctx, idList)
	if err != nil {
		log.Print("\"message\": failed to execute DBProvider.GetRecipeItemsByDocumentIds, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to load recipe items", "DatabaseError")
	}

	recipeItems := make(map[string][]*models.DocumentItem)
	for _, row := range rows {
		recipeID := row.RecipeID
		item := &models.DocumentItem{
			DId: row.ID,
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

			ItemTypePn: &row.ItemTypePn,
		}
		recipeItems[recipeID] = append(recipeItems[recipeID], item)
	}

	return recipeItems, nil
}
