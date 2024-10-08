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
    vat,
    vat_number,
    registration_number,
    is_active,
    address,
    locality,
    county_code,
    bank,
    iban
from core.partners
where ($1::uuid)='00000000-0000-0000-0000-000000000000' OR id=($1::uuid)
`

type GetPartnersRow struct {
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	Type               string
	Vat                bool
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	IsActive           bool
	Address            sql.NullString
	Locality           sql.NullString
	CountyCode         sql.NullString
	Bank               sql.NullString
	Iban               sql.NullString
}

func (q *Queries) GetPartners(ctx context.Context, partnerid uuid.UUID) ([]GetPartnersRow, error) {
	rows, err := q.db.Query(ctx, getPartners, partnerid)
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
			&i.Vat,
			&i.VatNumber,
			&i.RegistrationNumber,
			&i.IsActive,
			&i.Address,
			&i.Locality,
			&i.CountyCode,
			&i.Bank,
			&i.Iban,
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

const getPartnersByDocumentIds = `-- name: GetPartnersByDocumentIds :many
SELECT
    d.h_id,
    id,
    code,
    name,
    type,
    vat_number,
    registration_number,
    is_active
FROM
    core.partners p
        JOIN
    core.document_header d ON p.id = d.partner_id
WHERE
        d.h_id = ANY($1::uuid[])
`

type GetPartnersByDocumentIdsRow struct {
	HID                uuid.UUID
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	Type               string
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	IsActive           bool
}

func (q *Queries) GetPartnersByDocumentIds(ctx context.Context, dollar_1 []uuid.UUID) ([]GetPartnersByDocumentIdsRow, error) {
	rows, err := q.db.Query(ctx, getPartnersByDocumentIds, dollar_1)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetPartnersByDocumentIdsRow
	for rows.Next() {
		var i GetPartnersByDocumentIdsRow
		if err := rows.Scan(
			&i.HID,
			&i.ID,
			&i.Code,
			&i.Name,
			&i.Type,
			&i.VatNumber,
			&i.RegistrationNumber,
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
Insert into core.partners (code,name,type,vat,vat_number,registration_number,address,locality,county_code,bank,iban)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
RETURNING id
`

type InsertPartnerParams struct {
	Code               sql.NullString
	Name               string
	Type               string
	Vat                bool
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	Address            sql.NullString
	Locality           sql.NullString
	CountyCode         sql.NullString
	Bank               sql.NullString
	Iban               sql.NullString
}

func (q *Queries) InsertPartner(ctx context.Context, arg InsertPartnerParams) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, insertPartner,
		arg.Code,
		arg.Name,
		arg.Type,
		arg.Vat,
		arg.VatNumber,
		arg.RegistrationNumber,
		arg.Address,
		arg.Locality,
		arg.CountyCode,
		arg.Bank,
		arg.Iban,
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
    vat=$7,
    registration_number=$8,
    address=$9,
    locality=$10,
    county_code=$11,
    bank=$12,
    iban=$13
where id=$1
`

type UpdatePartnerParams struct {
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	IsActive           bool
	Type               string
	VatNumber          sql.NullString
	Vat                bool
	RegistrationNumber sql.NullString
	Address            sql.NullString
	Locality           sql.NullString
	CountyCode         sql.NullString
	Bank               sql.NullString
	Iban               sql.NullString
}

func (q *Queries) UpdatePartner(ctx context.Context, arg UpdatePartnerParams) error {
	_, err := q.db.Exec(ctx, updatePartner,
		arg.ID,
		arg.Code,
		arg.Name,
		arg.IsActive,
		arg.Type,
		arg.VatNumber,
		arg.Vat,
		arg.RegistrationNumber,
		arg.Address,
		arg.Locality,
		arg.CountyCode,
		arg.Bank,
		arg.Iban,
	)
	return err
}
