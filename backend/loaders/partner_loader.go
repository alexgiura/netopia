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

func fetchPartners(ctx context.Context, dbProvider *db.Queries, keys dataloader.Keys) ([]*dataloader.Result, error) {
	ids := make([]string, len(keys))
	for i, key := range keys {
		ids[i] = key.String()
	}

	partners, err := fetchPartnersByDocumentIds(ctx, dbProvider, ids)
	if err != nil {
		return nil, err
	}

	results := make([]*dataloader.Result, len(keys))
	for i, id := range ids {
		partner, ok := partners[id]
		if ok {
			results[i] = &dataloader.Result{Data: partner}
		} else {
			results[i] = &dataloader.Result{Data: nil}
		}
	}

	return results, nil
}

func fetchPartnersByDocumentIds(ctx context.Context, dbProvider *db.Queries, ids []string) (map[string]*models.Partner, error) {

	rows, err := dbProvider.GetPartnersByDocumentIds(ctx, util.StrArrayToUuidArray(ids))
	if err != nil {
		log.Print("\"message\": failed to execute DBProvider.GetPartnersByDocumentIds, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to load partner", "DatabaseError")
	}

	partners := make(map[string]*models.Partner)
	for _, row := range rows {
		documentID := row.HID.String()
		partners[documentID] = &models.Partner{
			ID:                 row.ID.String(),
			Code:               util.StringOrNil(row.Code),
			Type:               row.Type,
			Active:             row.IsActive,
			Name:               row.Name,
			VatNumber:          util.StringOrNil(row.VatNumber),
			RegistrationNumber: util.StringOrNil(row.RegistrationNumber),
			IndividualNumber:   util.StringOrNil(row.PersonalNumber),
		}
	}

	return partners, nil
}
