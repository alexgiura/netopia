package handlers

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.44

import (
	"backend/db"
	_err "backend/errors"
	"backend/graph/generated"
	"backend/graph/model"
	"backend/models"
	"backend/util"
	"context"
	"log"

	"github.com/jackc/pgconn"
	pgx "github.com/jackc/pgx/v4"
	"go.uber.org/zap"
)

// CreateNewAccount is the resolver for the createNewAccount field.
func (r *mutationResolver) CreateNewAccount(ctx context.Context, input model.UserInput) (*models.User, error) {
	//userId, ok := middleware.GetUserUUIDFromContext(ctx)
	//if !ok {
	//	return nil, _err.Error(ctx, "User not found in context", "UserNotFound")
	//}
	userId := input.ID

	var returnUser *models.User
	//
	if err := r.DBPool.BeginFunc(ctx, func(tx pgx.Tx) error {
		transaction := r.DBProvider.WithTx(tx)

		// Check if company exists
		//company, err := r._GetMyCompany(ctx)
		//if err != nil {
		//	return err
		//}
		//if company != nil {
		//	return _err.Error(ctx, "Account already exists", "AccountAlreadyExists")
		//}

		// Save User
		userRow, err := transaction.SaveUser(ctx, db.SaveUserParams{
			ID:          userId,
			Email:       input.Email,
			PhoneNumber: util.NullableStr(input.PhoneNumber),
		})
		if err != nil {
			err, ok := err.(*pgconn.PgError)
			if ok && err.Code == _err.Codes_Duplicate_Key {
				return _err.Error(ctx, "Email address already exists", "UserAlreadyExists")
			}
			log.Printf("Failed to save user in DB: %v", err)
			return _err.Error(ctx, "Failed to save user in DB", "DatabaseError")
		}

		// Save Company
		_, err = transaction.SaveCompany(ctx, db.SaveCompanyParams{
			Name:               input.Company.Name,
			Vat:                input.Company.Vat,
			VatNumber:          input.Company.VatNumber,
			RegistrationNumber: util.NullableStr(input.Company.RegistrationNumber),
			Address:            *input.Company.CompanyAddress.Address,
			Locality:           util.NullableStr(input.Company.CompanyAddress.Locality),
			CountyCode:         util.NullableStr(input.Company.CompanyAddress.CountyCode),
		})
		if err != nil {
			err, ok := err.(*pgconn.PgError)
			if ok && err.Code == _err.Codes_Duplicate_Key {
				return _err.Error(ctx, "Company already exists", "CompanyAlreadyExists")
			}
			log.Printf("Failed to save company in DB: %v", err)
			return _err.Error(ctx, "Failed to save company in DB", "DatabaseError")
		}
		returnUser = &models.User{
			Id:          userRow.ID,
			Email:       userRow.Email,
			PhoneNumber: &userRow.PhoneNumber,
		}

		return nil
	}); err != nil {
		return nil, err
	}
	return returnUser, nil
}

// GetUser is the resolver for the getUser field.
func (r *queryResolver) GetUser(ctx context.Context, userID string) (*models.User, error) {
	//// Get the user ID from the context
	//userId, ok := middleware.GetUserUUIDFromContext(ctx)
	//if !ok {
	//	return nil, _err.Error(ctx, "User not found in context", "UserNotFound")
	//}
	userId := userID
	user, err := r.DBProvider.GetUserById(ctx, userId)
	if err != nil {
		r.Logger.Error("failed to execute DBProvider.GetUserById", zap.Error(err))
		return nil, _err.Error(ctx, "User not found in DB", "InternalError")
	}
	return &models.User{
		Id:          user.ID,
		Email:       user.Email,
		PhoneNumber: util.StringOrNil(user.PhoneNumber),
	}, nil
}

// Company is the resolver for the company field.
func (r *userResolver) Company(ctx context.Context, obj *models.User) (*models.Company, error) {
	company, err := r._GetMyCompany(ctx)
	if err != nil {
		return nil, err
	}
	return company, nil
}

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

type userResolver struct{ *Resolver }
