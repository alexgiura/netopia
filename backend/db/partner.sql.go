// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: partner.sql

package db

import (
	"context"
	"database/sql"

	"github.com/google/uuid"
)

const getPartners = `-- name: GetPartners :many
select
    id,
    code,
    name,
    type,
    vat_number,
    registration_number,
    personal_number,
    is_active
from core.partners
where  (code like ('%' || $1 || '%') OR code IS NULL) and name like '%' || $2 || '%' and type like '%' || $3|| '%' and tax_id like '%' || $4|| '%'
`

type GetPartnersParams struct {
	Code  sql.NullString
	Name  sql.NullString
	Type  sql.NullString
	TaxID sql.NullString
}

type GetPartnersRow struct {
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	Type               string
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	PersonalNumber     sql.NullString
	IsActive           bool
}

func (q *Queries) GetPartners(ctx context.Context, arg GetPartnersParams) ([]GetPartnersRow, error) {
	rows, err := q.db.Query(ctx, getPartners,
		arg.Code,
		arg.Name,
		arg.Type,
		arg.TaxID,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetPartnersRow
	for rows.Next() {
		var i GetPartnersRow
		if err := rows.Scan(
			&i.ID,
			&i.Code,
			&i.Name,
			&i.Type,
			&i.VatNumber,
			&i.RegistrationNumber,
			&i.PersonalNumber,
			&i.IsActive,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const insertPartner = `-- name: InsertPartner :one
Insert into core.partners (code,name,type,vat_number,registration_number,personal_number)
VALUES ($1,$2,$3,$4,$5,$6)
RETURNING id
`

type InsertPartnerParams struct {
	Code               sql.NullString
	Name               string
	Type               string
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	PersonalNumber     sql.NullString
}

func (q *Queries) InsertPartner(ctx context.Context, arg InsertPartnerParams) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, insertPartner,
		arg.Code,
		arg.Name,
		arg.Type,
		arg.VatNumber,
		arg.RegistrationNumber,
		arg.PersonalNumber,
	)
	var id uuid.UUID
	err := row.Scan(&id)
	return id, err
}

const updatePartner = `-- name: UpdatePartner :exec
Update core.partners
Set code=$2,
    name=$3,
    is_active=$4,
    type=$5,
    vat_number=$6,
    registration_number=$7,
    personal_number=$8
where id=$1
`

type UpdatePartnerParams struct {
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	IsActive           bool
	Type               string
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	PersonalNumber     sql.NullString
}

func (q *Queries) UpdatePartner(ctx context.Context, arg UpdatePartnerParams) error {
	_, err := q.db.Exec(ctx, updatePartner,
		arg.ID,
		arg.Code,
		arg.Name,
		arg.IsActive,
		arg.Type,
		arg.VatNumber,
		arg.RegistrationNumber,
		arg.PersonalNumber,
	)
	return err
}
