// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: company.sql

package db

import (
	"context"
	"database/sql"

	"github.com/google/uuid"
)

const getCompany = `-- name: GetCompany :one
SELECT id,
       name,
       vat,
       vat_number,
       registration_number,
       address,
       locality,
       county_code,
       email,
       bank_name,
       bank_account,
       frontend_url
from core.company
    LIMIT 1
`

type GetCompanyRow struct {
	ID                 uuid.UUID
	Name               string
	Vat                bool
	VatNumber          string
	RegistrationNumber sql.NullString
	Address            string
	Locality           sql.NullString
	CountyCode         sql.NullString
	Email              sql.NullString
	BankName           sql.NullString
	BankAccount        sql.NullString
	FrontendUrl        sql.NullString
}

func (q *Queries) GetCompany(ctx context.Context) (GetCompanyRow, error) {
	row := q.db.QueryRow(ctx, getCompany)
	var i GetCompanyRow
	err := row.Scan(
		&i.ID,
		&i.Name,
		&i.Vat,
		&i.VatNumber,
		&i.RegistrationNumber,
		&i.Address,
		&i.Locality,
		&i.CountyCode,
		&i.Email,
		&i.BankName,
		&i.BankAccount,
		&i.FrontendUrl,
	)
	return i, err
}

const saveCompany = `-- name: SaveCompany :one
INSERT INTO core.company(name,vat,vat_number,registration_number,address, locality,county_code)
values ($1,$2,$3,$4,$5,$6,$7)
    RETURNING
    name::text,
    vat::bool,
    vat_number::text,
    registration_number::text,
    address::text,
    locality::text,
    county_code::text
`

type SaveCompanyParams struct {
	Name               string
	Vat                bool
	VatNumber          string
	RegistrationNumber sql.NullString
	Address            string
	Locality           sql.NullString
	CountyCode         sql.NullString
}

type SaveCompanyRow struct {
	Name               string
	Vat                bool
	VatNumber          string
	RegistrationNumber string
	Address            string
	Locality           string
	CountyCode         string
}

func (q *Queries) SaveCompany(ctx context.Context, arg SaveCompanyParams) (SaveCompanyRow, error) {
	row := q.db.QueryRow(ctx, saveCompany,
		arg.Name,
		arg.Vat,
		arg.VatNumber,
		arg.RegistrationNumber,
		arg.Address,
		arg.Locality,
		arg.CountyCode,
	)
	var i SaveCompanyRow
	err := row.Scan(
		&i.Name,
		&i.Vat,
		&i.VatNumber,
		&i.RegistrationNumber,
		&i.Address,
		&i.Locality,
		&i.CountyCode,
	)
	return i, err
}
