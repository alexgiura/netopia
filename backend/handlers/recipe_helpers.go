package handlers

import (
	"backend/db"
	_err "backend/errors"
	"backend/graph/model"
	"backend/models"
	"backend/util"
	"context"
	"errors"
	"github.com/jackc/pgconn"
	"log"

	"github.com/jackc/pgx/v4"
	"go.uber.org/zap"
)

func (r *Resolver) _getRecipeItems(ctx context.Context, transaction *db.Queries, recipeId int32) ([]*models.DocumentItem, error) {
	// Get all item subgroups for the given group ID
	rows, err := transaction.GetRecipeItemsById(ctx, recipeId)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetRecipeItemsById, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get recipe items", "DatabaseError")

	}

	// Create an array to hold all subgroup items
	var recipeItems []*models.DocumentItem

	// Loop through each subgroup item and add it to the array
	for _, row := range rows {
		itemTypePn := row.ItemTypePn
		recipeItem := &models.DocumentItem{
			Item: models.Item{
				ID:   row.ItemID.String(),
				Code: util.StringOrNil(row.ItemCode),
				Name: row.ItemName,
				Um: models.Um{
					ID:   int(row.UmID),
					Name: row.UmName,
				},
			},

			Quantity: row.Quantity,

			ItemTypePn: &itemTypePn,
		}

		recipeItems = append(recipeItems, recipeItem)
	}

	return recipeItems, nil
}

func (r *Resolver) _getRecipeById(ctx context.Context, transaction *db.Queries, recipeId int32) (*models.Recipe, error) {

	row, err := transaction.GetRecipeById(ctx, recipeId)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetRecipeItemsById, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to get recipe items", "DatabaseError")

	}

	return &models.Recipe{
		ID:       int(row.ID),
		Name:     row.Name,
		IsActive: row.IsActive,
	}, nil
}

func (r *Resolver) _insertRecipe(ctx context.Context, input model.SaveRecipeInput) (*models.Recipe, error) {
	returnRecipe := &models.Recipe{}
	if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)

		hId, err := transaction.SaveRecipe(ctx, db.SaveRecipeParams{
			Name:     input.Name,
			IsActive: input.IsActive,
		})

		if err != nil {
			if pgErr, ok := err.(*pgconn.PgError); ok {

				switch pgErr.Code {
				case "23505":
					return _err.Error(ctx, "Recipe already exists", "EntryAlreadyExists")
				default:
					return _err.Error(ctx, "Database error occurred", "DatabaseError")
				}
			}
			log.Print("\"message\":Failed to save recipe, "+"\"error\": ", err.Error())
			return err
		}

		// Save document details in DB
		for _, item := range input.DocumentItems {

			_, err := transaction.SaveRecipeItems(ctx, db.SaveRecipeItemsParams{
				RecipeID:           hId,
				ItemID:             util.StrToUUID(&item.ItemID),
				Quantity:           item.Quantity,
				ProductionItemType: *item.ItemTypePn,
			})
			if err != nil {
				log.Print("\"message\":Failed to save recipe items, "+"\"error\": ", err.Error())
				return err
			}

		}

		returnRecipe, err = r._getRecipeById(ctx, transaction, hId)
		if err != nil {
			return err
		}

		return nil
	}); err != nil {
		return nil, err
	}

	return returnRecipe, nil
}

func (r *Resolver) _updateRecipe(ctx context.Context, input model.SaveRecipeInput) (*models.Recipe, error) {
	returnRecipe := &models.Recipe{}
	if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)

		err := transaction.UpdateRecipe(ctx, db.UpdateRecipeParams{
			ID:       int32(*input.ID),
			Name:     input.Name,
			IsActive: input.IsActive,
		})

		if err != nil {
			if pgErr, ok := err.(*pgconn.PgError); ok {
				switch pgErr.Code {
				case "23505":
					return _err.Error(ctx, "Recipe already exists", "EntryAlreadyExists")
				default:
					return _err.Error(ctx, "Database error occurred", "DatabaseError")
				}
			}
			log.Print("\"message\":Failed to update recipe, "+"\"error\": ", err.Error())

			return err
		}

		// Delete document details from DB
		err2 := transaction.DeleteRecipeItems(ctx, int32(*input.ID))
		if err2 != nil {
			r.Logger.Error("failed to delete recipe items", zap.Error(err2))
			return err2
		}

		// Save document details in DB
		for _, item := range input.DocumentItems {
			_, err := transaction.SaveRecipeItems(ctx, db.SaveRecipeItemsParams{
				RecipeID:           int32(*input.ID),
				ItemID:             util.StrToUUID(&item.ItemID),
				Quantity:           item.Quantity,
				ProductionItemType: *item.ItemTypePn,
			})
			if err != nil {
				r.Logger.Error("failed to save recipe details", zap.Error(err))
				return err
			}
		}

		returnRecipe, err = r._getRecipeById(ctx, transaction, int32(*input.ID))
		if err != nil {
			return err
		}

		return nil
	}); err != nil {
		return nil, err
	}

	return returnRecipe, nil
}
