package models

import "github.com/graph-gophers/dataloader"

type Loaders struct {
	PartnerLoader      *dataloader.Loader
	DocumentItemLoader *dataloader.Loader
	RecipeItemLoader   *dataloader.Loader
	CurrencyLoader     *dataloader.Loader
	// Add other loaders here
}
