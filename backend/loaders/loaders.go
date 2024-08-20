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
		PartnerLoader: dataloader.NewBatchedLoader(func(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
			results, err := fetchPartners(ctx, dbProvider, keys)
			if err != nil {
				log.Printf("\"message\": \"Failed to fetch partners\", \"error\": \"%v\"", err)
				// Return an error result for each key
				errorResults := make([]*dataloader.Result, len(keys))
				for i := range keys {
					errorResults[i] = &dataloader.Result{Error: err}
				}
				return errorResults
			}
			return results
		}),
		DocumentItemLoader: dataloader.NewBatchedLoader(func(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
			results, err := fetchDocumentItems(ctx, dbProvider, keys)
			if err != nil {
				log.Printf("\"message\": \"Failed to fetch document items\", \"error\": \"%v\"", err)
				// Return an error result for each key
				errorResults := make([]*dataloader.Result, len(keys))
				for i := range keys {
					errorResults[i] = &dataloader.Result{Error: err}
				}
				return errorResults
			}
			return results
		}),
		RecipeItemLoader: dataloader.NewBatchedLoader(func(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
			results, err := fetchRecipeItems(ctx, dbProvider, keys)
			if err != nil {
				log.Printf("\"message\": \"Failed to fetch recipe items\", \"error\": \"%v\"", err)
				// Return an error result for each key
				errorResults := make([]*dataloader.Result, len(keys))
				for i := range keys {
					errorResults[i] = &dataloader.Result{Error: err}
				}
				return errorResults
			}
			return results
		}),
		CurrencyLoader: dataloader.NewBatchedLoader(func(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
			results, err := fetchCurrencies(ctx, dbProvider, keys)
			if err != nil {
				log.Printf("\"message\": \"Failed to fetch currencies\", \"error\": \"%v\"", err)
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
