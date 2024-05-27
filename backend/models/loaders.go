package models

import "github.com/graph-gophers/dataloader"

type Loaders struct {
	PartnerLoader      *dataloader.Loader
	DocumentItemLoader *dataloader.Loader
	// Add other loaders here
}
