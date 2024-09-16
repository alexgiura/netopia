package loaders

import (
	"backend/db"
	"backend/models"
	"context"
	"github.com/graph-gophers/dataloader"
	"log"
)

func NewLoaders(dbProvider *db.Queries) *models.Loaders {
	return &models.Loaders{
		DepartmentLoader: dataloader.NewBatchedLoader(func(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
			results, err := fetchDepartments(ctx, dbProvider, keys)
			if err != nil {
				log.Printf("\"message\": \"Failed to fetch departments\", \"error\": \"%v\"", err)
				// Return an error result for each key
				errorResults := make([]*dataloader.Result, len(keys))
				for i := range keys {
					errorResults[i] = &dataloader.Result{Error: err}
				}
				return errorResults
			}
			return results
		}),
	}
}
