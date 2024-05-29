package handlers

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.44

import (
	_err "backend/errors"
	"backend/models"
	"context"
)

// GetCompany is the resolver for the getCompany field.
func (r *queryResolver) GetCompany(ctx context.Context) (*models.Company, error) {
	company, err := r._GetMyCompany(ctx)
	if err != nil {
		return nil, err
	}
	return company, nil
}

// GetCompanyByTaxID is the resolver for the getCompanyByTaxId field.
func (r *queryResolver) GetCompanyByTaxID(ctx context.Context, taxID *string) (*models.Company, error) {
	company, err := r._GetCompanyInfo(ctx, taxID)
	if err != nil || company == nil {
		return nil, _err.Error(ctx, "InvalidTaxId", "InternalError")
	}
	return company, nil
}

// GetCompanyByTaxID is the resolver for the getCompanyByTaxId field.
func (r *queryResolver) GetCompanyByTaxID(ctx context.Context, taxID *string) (*models.Company, error) {
	company, err := r._GetCompanyInfo(ctx, taxID)
	if err != nil || company == nil {
		return nil, _err.Error(ctx, "InvalidTaxId", "InternalError")
	}
	return company, nil
}
