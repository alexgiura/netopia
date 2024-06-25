package handlers

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.44

import (
	"backend/db"
	_err "backend/errors"
	"backend/graph/model"
	"backend/models"
	"backend/util"
	"context"
	"errors"
	"log"

	"github.com/google/uuid"
	pgx "github.com/jackc/pgx/v4"
	"go.uber.org/zap"
)

// SaveItem is the resolver for the saveItem field.
func (r *mutationResolver) SaveItem(ctx context.Context, input model.ItemInput) (*string, error) {
	if input.ID == nil {
		_, err := r.DBProvider.InsertItem(ctx, db.InsertItemParams{
			Code:       util.NullableStr(input.Code),
			Name:       input.Name,
			IDUm:       int32(input.IDUm),
			IDVat:      int32(input.IDVat),
			IsActive:   input.IsActive,
			IsStock:    input.IsStock,
			IDCategory: util.NullableInt32(input.IDCategory),
		})
		if err != nil {

			log.Print("\"message\":Failed to insert item, "+"\"error\": ", err.Error())
			return nil, _err.Error(ctx, "InsertFailed", "DatabaseError")
		}
	} else {
		IdUuid, err := uuid.Parse(*input.ID)
		if err != nil {
			log.Print("\"message\":Failed to parse ID, "+"\"error\": ", err.Error())
			return nil, _err.Error(ctx, "InvalidItemId", "InternalError")
		}
		err = r.DBProvider.UpdateItem(ctx, db.UpdateItemParams{
			ID:         IdUuid,
			Code:       util.NullableStr(input.Code),
			Name:       input.Name,
			IDUm:       int32(input.IDUm),
			IDVat:      int32(input.IDVat),
			IsActive:   input.IsActive,
			IsStock:    input.IsStock,
			IDCategory: util.NullableInt32(input.IDCategory),
		})
		if err != nil {
			log.Print("\"message\":Failed to update item, "+"\"error\": ", err.Error())
			return nil, _err.Error(ctx, "UpdateFailed", "DatabaseError")
		}
	}
	response := "success"
	return &response, nil
}

// SaveUm is the resolver for the saveUM field.
func (r *mutationResolver) SaveUm(ctx context.Context, input model.UmInput) (*models.Um, error) {
	if input.ID == nil {
		// Insert new UM
		newUm, err := r.DBProvider.InsertUm(ctx, db.InsertUmParams{
			Name:     input.Name,
			Code:     input.Code,
			IsActive: input.IsActive,
		})
		if err != nil {
			log.Printf("\"message\": \"Failed to execute DBProvider.InsertUm\", \"error\": \"%s\"", err.Error())
			return nil, _err.Error(ctx, "InsertFailed", "DatabaseError")
		}
		return &models.Um{
			ID:       int(newUm.ID),
			Name:     newUm.Name,
			Code:     newUm.Code,
			IsActive: newUm.IsActive,
		}, nil
	} else {
		// Update existing UM
		updatedUm, err := r.DBProvider.UpdateUm(ctx, db.UpdateUmParams{
			ID:       int32(*input.ID),
			Name:     input.Name,
			Code:     input.Code,
			IsActive: input.IsActive,
		})
		if err != nil {
			log.Printf("\"message\": \"Failed to execute DBProvider.UpdateUm\", \"error\": \"%s\"", err.Error())
			return nil, _err.Error(ctx, "UpdateFailed", "DatabaseError")
		}
		return &models.Um{
			ID:       int(updatedUm.ID),
			Name:     updatedUm.Name,
			Code:     updatedUm.Code,
			IsActive: updatedUm.IsActive,
		}, nil
	}

	return nil, nil
}

// SaveItemCategory is the resolver for the saveItemCategory field.
func (r *mutationResolver) SaveItemCategory(ctx context.Context, input model.ItemCategoryInput) (*models.ItemCategory, error) {
	if input.ID == nil {
		newCategory, err := r.DBProvider.InsertItemCategory(ctx, db.InsertItemCategoryParams{
			Name:       input.Name,
			IsActive:   input.IsActive,
			GeneratePn: input.GeneratePn,
		})
		if err != nil {
			log.Print("\"message\":Failed to insert item category, "+"\"error\": ", err.Error())
			return nil, _err.Error(ctx, "InsertFailed", "DatabaseError")
		}
		return &models.ItemCategory{
			ID:         int(newCategory.ID),
			Name:       newCategory.Name,
			IsActive:   newCategory.IsActive,
			GeneratePn: newCategory.GeneratePn,
		}, nil
	} else {
		updatedCategory, err := r.DBProvider.UpdateItemCategory(ctx, db.UpdateItemCategoryParams{
			ID:         int32(*input.ID),
			Name:       input.Name,
			IsActive:   input.IsActive,
			GeneratePn: input.GeneratePn,
		})
		if err != nil {
			log.Print("\"message\":Failed to update item category, "+"\"error\": ", err.Error())
			return nil, _err.Error(ctx, "UpdateFailed", "DatabaseError")
		}
		return &models.ItemCategory{
			ID:         int(updatedCategory.ID),
			Name:       updatedCategory.Name,
			IsActive:   updatedCategory.IsActive,
			GeneratePn: updatedCategory.GeneratePn,
		}, nil
	}
	return nil, nil
}

// GetItems is the resolver for the getItems field.
func (r *queryResolver) GetItems(ctx context.Context, input model.GetItemsInput) ([]*models.Item, error) {
	rows, err := r.DBProvider.GetItems(ctx, util.IntArrayToInt32Array(input.CategoryList))

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		r.Logger.Error("failed to execute DBProvider.GetItems", zap.Error(err))
		return nil, _err.Error(ctx, "Failed to get items", "DatabaseError")
	}

	items := make([]*models.Item, 0)

	for _, row := range rows {

		var category *models.ItemCategory

		if row.CategoryID.Valid {
			category = &models.ItemCategory{
				ID:         *util.IntOrNil(row.CategoryID),
				Name:       *util.StringOrNil(row.CategoryName),
				IsActive:   *util.BoolOrNil(row.CategoryIsActive),
				GeneratePn: *util.BoolOrNil(row.CategoryGeneratePn),
			}
		}

		item := &models.Item{

			ID:       row.ID.String(),
			Code:     util.StringOrNil(row.Code),
			Name:     row.Name,
			IsActive: row.IsActive,
			IsStock:  row.IsStock,
			Um: models.Um{
				ID:   int(row.UmID),
				Name: row.UmName,
			},
			Vat: models.Vat{
				ID:      int(row.VatID),
				Name:    row.VatName,
				Percent: row.VatPercent,
			},
			Category: category,
		}

		items = append(items, item)

	}

	return items, nil
}

// GetUmList is the resolver for the getUmList field.
func (r *queryResolver) GetUmList(ctx context.Context) ([]*models.Um, error) {
	rows, err := r.DBProvider.GetUmList(ctx)
	if err != nil {
		log.Print("\"message\":Failed to get UMs, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get UMs", "DatabaseError")
	}
	umList := make([]*models.Um, 0)
	for _, row := range rows {
		um := &models.Um{
			ID:       int(row.ID),
			Name:     row.Name,
			Code:     row.Code,
			IsActive: row.IsActive,
		}

		umList = append(umList, um)
	}
	return umList, nil
}

// GetVatList is the resolver for the getVatList field.
func (r *queryResolver) GetVatList(ctx context.Context) ([]*models.Vat, error) {
	rows, err := r.DBProvider.GetVatList(ctx)
	if err != nil {
		log.Print("\"message\":Failed to get VATs, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get VATs", "DatabaseError")
	}
	vatList := make([]*models.Vat, 0)
	for _, row := range rows {
		um := &models.Vat{
			ID:       int(row.ID),
			Name:     row.Name,
			Percent:  row.Percent,
			IsActive: row.IsActive,
		}

		vatList = append(vatList, um)
	}
	return vatList, nil
}

// GetItemCategoryList is the resolver for the getItemCategoryList field.
func (r *queryResolver) GetItemCategoryList(ctx context.Context) ([]*models.ItemCategory, error) {
	rows, err := r.DBProvider.GetItemCategoryList(ctx)
	if err != nil {
		log.Print("\"message\":Failed to get Item Category List, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get Item Category List", "DatabaseError")
	}
	itemCategoryList := make([]*models.ItemCategory, 0)
	for _, row := range rows {
		itemCategory := &models.ItemCategory{
			ID:         int(row.ID),
			Name:       row.Name,
			IsActive:   row.IsActive,
			GeneratePn: row.GeneratePn,
		}

		itemCategoryList = append(itemCategoryList, itemCategory)
	}
	return itemCategoryList, nil
}
