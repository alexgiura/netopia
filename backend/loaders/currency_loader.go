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

func fetchCurrencies(ctx context.Context, dbProvider *db.Queries, keys dataloader.Keys) ([]*dataloader.Result, error) {
	ids := make([]string, len(keys))
	for i, key := range keys {
		ids[i] = key.String()
	}

	currencies, err := fetchCurrenciesByDocumentIds(ctx, dbProvider, ids)
	if err != nil {
		return nil, err
	}

	results := make([]*dataloader.Result, len(keys))
	for i, id := range ids {
		currency, ok := currencies[id]
		if ok {
			results[i] = &dataloader.Result{Data: currency}
		} else {
			results[i] = &dataloader.Result{Data: nil}
		}
	}

	return results, nil
}

func fetchCurrenciesByDocumentIds(ctx context.Context, dbProvider *db.Queries, ids []string) (map[string]*models.Currency, error) {

	rows, err := dbProvider.GetCurrenciesByDocumentIds(ctx, util.StrArrayToUuidArray(ids))
	if err != nil {
		log.Print("\"message\": failed to execute DBProvider.GetCurrenciesByDocumentIds, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to load currency", "DatabaseError")
	}

	currencies := make(map[string]*models.Currency)
	for _, row := range rows {
		documentID := row.HID.String()
		currencies[documentID] = &models.Currency{
			ID:        int(row.ID),
			Name:      row.Name,
			IsPrimary: row.IsPrimary,
		}
	}

	return currencies, nil
}
