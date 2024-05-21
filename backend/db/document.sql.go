// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: document.sql

package db

import (
	"context"
	"database/sql"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgtype"
)

const cloneAuthorizationWithToken = `-- name: CloneAuthorizationWithToken :one
WITH auth AS (
    SELECT company_id, code, status FROM core.efactura_authorizations
    WHERE efactura_authorizations.a_id=$1
)
INSERT INTO core.efactura_authorizations(company_id, code, status, token, token_expires_at)
    SELECT auth.company_id, auth.code, auth.status, $2, $3 FROM auth
    RETURNING a_id
`

type CloneAuthorizationWithTokenParams struct {
	AID            uuid.UUID
	Token          pgtype.JSON
	TokenExpiresAt sql.NullTime
}

func (q *Queries) CloneAuthorizationWithToken(ctx context.Context, arg CloneAuthorizationWithTokenParams) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, cloneAuthorizationWithToken, arg.AID, arg.Token, arg.TokenExpiresAt)
	var a_id uuid.UUID
	err := row.Scan(&a_id)
	return a_id, err
}

const createEfacturaDocument = `-- name: CreateEfacturaDocument :one
INSERT INTO core.efactura_documents(h_id, x_id, status)
VALUES ($1,$2,$3) RETURNING e_id
`

type CreateEfacturaDocumentParams struct {
	HID    uuid.UUID
	XID    int64
	Status CoreEfacturaDocumentStatus
}

func (q *Queries) CreateEfacturaDocument(ctx context.Context, arg CreateEfacturaDocumentParams) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, createEfacturaDocument, arg.HID, arg.XID, arg.Status)
	var e_id uuid.UUID
	err := row.Scan(&e_id)
	return e_id, err
}

const createEfacturaDocumentUpload = `-- name: CreateEfacturaDocumentUpload :one
WITH insert_upload AS (
    INSERT INTO core.efactura_document_uploads(e_id, x_id, status, upload_index)
    VALUES ($1, $2, $3, $4)
    RETURNING id
)
UPDATE core.efactura_documents AS ed
SET x_id=$2,
    status=$3,
    upload_index=$4,
    u_id = (SELECT id FROM insert_upload)
WHERE ed.e_id=$1
RETURNING u_id::bigint
`

type CreateEfacturaDocumentUploadParams struct {
	EID         uuid.UUID
	XID         int64
	Status      CoreEfacturaDocumentStatus
	UploadIndex sql.NullInt64
}

func (q *Queries) CreateEfacturaDocumentUpload(ctx context.Context, arg CreateEfacturaDocumentUploadParams) (int64, error) {
	row := q.db.QueryRow(ctx, createEfacturaDocumentUpload,
		arg.EID,
		arg.XID,
		arg.Status,
		arg.UploadIndex,
	)
	var u_id int64
	err := row.Scan(&u_id)
	return u_id, err
}

const createEfacturaMessage = `-- name: CreateEfacturaMessage :one
INSERT INTO core.efactura_messages(u_id, state, download_id, error_message)
VALUES ($1,$2,$3,$4) RETURNING id
`

type CreateEfacturaMessageParams struct {
	UID          int64
	State        CoreEfacturaMessageState
	DownloadID   sql.NullInt64
	ErrorMessage sql.NullString
}

func (q *Queries) CreateEfacturaMessage(ctx context.Context, arg CreateEfacturaMessageParams) (int64, error) {
	row := q.db.QueryRow(ctx, createEfacturaMessage,
		arg.UID,
		arg.State,
		arg.DownloadID,
		arg.ErrorMessage,
	)
	var id int64
	err := row.Scan(&id)
	return id, err
}

const createEfacturaXMLDocument = `-- name: CreateEfacturaXMLDocument :one
INSERT INTO core.efactura_xml_documents(h_id, invoice_xml, invoice_md5_sum)
VALUES ($1,$2,$3) RETURNING id
`

type CreateEfacturaXMLDocumentParams struct {
	HID           uuid.UUID
	InvoiceXml    string
	InvoiceMd5Sum string
}

func (q *Queries) CreateEfacturaXMLDocument(ctx context.Context, arg CreateEfacturaXMLDocumentParams) (int64, error) {
	row := q.db.QueryRow(ctx, createEfacturaXMLDocument, arg.HID, arg.InvoiceXml, arg.InvoiceMd5Sum)
	var id int64
	err := row.Scan(&id)
	return id, err
}

const deleteDocument = `-- name: DeleteDocument :exec
Update core.document_header
Set is_deleted=true
where h_id=$1
`

func (q *Queries) DeleteDocument(ctx context.Context, hID uuid.UUID) error {
	_, err := q.db.Exec(ctx, deleteDocument, hID)
	return err
}

const fetchLastAuthorization = `-- name: FetchLastAuthorization :one
SELECT a_id, token
FROM core.efactura_authorizations ea
INNER JOIN core.company c ON ea.company_id = c.id
WHERE ea.status='success'
ORDER BY ea.token_expires_at DESC LIMIT 1
`

type FetchLastAuthorizationRow struct {
	AID   uuid.UUID
	Token pgtype.JSON
}

func (q *Queries) FetchLastAuthorization(ctx context.Context) (FetchLastAuthorizationRow, error) {
	row := q.db.QueryRow(ctx, fetchLastAuthorization)
	var i FetchLastAuthorizationRow
	err := row.Scan(&i.AID, &i.Token)
	return i, err
}

const generateAuthorization = `-- name: GenerateAuthorization :one
INSERT INTO core.efactura_authorizations(company_id) SELECT id FROM core.company LIMIT 1
    RETURNING a_id
`

func (q *Queries) GenerateAuthorization(ctx context.Context) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, generateAuthorization)
	var a_id uuid.UUID
	err := row.Scan(&a_id)
	return a_id, err
}

const getCurrencyList = `-- name: GetCurrencyList :many
select id, name from core.document_currency
`

func (q *Queries) GetCurrencyList(ctx context.Context) ([]CoreDocumentCurrency, error) {
	rows, err := q.db.Query(ctx, getCurrencyList)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []CoreDocumentCurrency
	for rows.Next() {
		var i CoreDocumentCurrency
		if err := rows.Scan(&i.ID, &i.Name); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getDocumentDetails = `-- name: GetDocumentDetails :one
SELECT quantity::float,h_id,d_id from core.document_details where d_id=$1
`

type GetDocumentDetailsRow struct {
	Quantity float64
	HID      uuid.UUID
	DID      uuid.UUID
}

func (q *Queries) GetDocumentDetails(ctx context.Context, dID uuid.UUID) (GetDocumentDetailsRow, error) {
	row := q.db.QueryRow(ctx, getDocumentDetails, dID)
	var i GetDocumentDetailsRow
	err := row.Scan(&i.Quantity, &i.HID, &i.DID)
	return i, err
}

const getDocumentHeader = `-- name: GetDocumentHeader :one
Select
    h_id,
    dt.id as document_type_id,
    dt.name_ro as document_type_name_ro,
    dt.name_en as document_type_name_en,
    series,
    number,
    date,
    due_date,
    d.partner_id as partner_id,
    d.document_partner_billing_details_id,
    pa.name as partner_name,
    representative_id as person_id,
    pe.name as person_name,
    notes,
    dc.name AS currency,
    is_deleted
from core.document_header as d
left join core.partners as pa
on pa.id=d.partner_id
left join core.persons as pe
on pe.id=d.representative_id
left join core.document_types as dt
on dt.id=d.document_type
left join core.document_currency dc
on d.currency_id = dc.id
where h_id=$1
`

type GetDocumentHeaderRow struct {
	HID                             uuid.UUID
	DocumentTypeID                  sql.NullInt32
	DocumentTypeNameRo              sql.NullString
	DocumentTypeNameEn              sql.NullString
	Series                          sql.NullString
	Number                          string
	Date                            time.Time
	DueDate                         sql.NullTime
	PartnerID                       uuid.UUID
	DocumentPartnerBillingDetailsID sql.NullInt32
	PartnerName                     sql.NullString
	PersonID                        uuid.NullUUID
	PersonName                      sql.NullString
	Notes                           sql.NullString
	Currency                        sql.NullString
	IsDeleted                       bool
}

func (q *Queries) GetDocumentHeader(ctx context.Context, hID uuid.UUID) (GetDocumentHeaderRow, error) {
	row := q.db.QueryRow(ctx, getDocumentHeader, hID)
	var i GetDocumentHeaderRow
	err := row.Scan(
		&i.HID,
		&i.DocumentTypeID,
		&i.DocumentTypeNameRo,
		&i.DocumentTypeNameEn,
		&i.Series,
		&i.Number,
		&i.Date,
		&i.DueDate,
		&i.PartnerID,
		&i.DocumentPartnerBillingDetailsID,
		&i.PartnerName,
		&i.PersonID,
		&i.PersonName,
		&i.Notes,
		&i.Currency,
		&i.IsDeleted,
	)
	return i, err
}

const getDocumentHeaderPartner = `-- name: GetDocumentHeaderPartner :one
Select
    id,
    code,
    name,
    is_active,
    type,
<<<<<<< HEAD
=======
    vat,
>>>>>>> origin/dev
    vat_number,
    registration_number,
    personal_number
from core.partners
where id=$1
`

type GetDocumentHeaderPartnerRow struct {
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	IsActive           bool
	Type               string
<<<<<<< HEAD
=======
	Vat                bool
>>>>>>> origin/dev
	VatNumber          sql.NullString
	RegistrationNumber sql.NullString
	PersonalNumber     sql.NullString
}

func (q *Queries) GetDocumentHeaderPartner(ctx context.Context, id uuid.UUID) (GetDocumentHeaderPartnerRow, error) {
	row := q.db.QueryRow(ctx, getDocumentHeaderPartner, id)
	var i GetDocumentHeaderPartnerRow
	err := row.Scan(
		&i.ID,
		&i.Code,
		&i.Name,
		&i.IsActive,
		&i.Type,
<<<<<<< HEAD
=======
		&i.Vat,
>>>>>>> origin/dev
		&i.VatNumber,
		&i.RegistrationNumber,
		&i.PersonalNumber,
	)
	return i, err
}

const getDocumentHeaderPartnerBillingDetails = `-- name: GetDocumentHeaderPartnerBillingDetails :one
SELECT p.id, p.code, p.name, p.is_active, p.type, p.vat_number, p.vat, p.registration_number, p.personal_number, p.address, p.locality, p.county_code, p.created_at, bd.id, bd.partner_id, bd.vat, bd.registration_number, bd.address, bd.locality, bd.county_code, bd.created_at
FROM core.document_partner_billing_details bd
         INNER JOIN core.partners p
                    ON p.id = bd.partner_id
WHERE bd.id=$1
`

type GetDocumentHeaderPartnerBillingDetailsRow struct {
	CorePartner                      CorePartner
	CoreDocumentPartnerBillingDetail CoreDocumentPartnerBillingDetail
}

func (q *Queries) GetDocumentHeaderPartnerBillingDetails(ctx context.Context, id int32) (GetDocumentHeaderPartnerBillingDetailsRow, error) {
	row := q.db.QueryRow(ctx, getDocumentHeaderPartnerBillingDetails, id)
	var i GetDocumentHeaderPartnerBillingDetailsRow
	err := row.Scan(
		&i.CorePartner.ID,
		&i.CorePartner.Code,
		&i.CorePartner.Name,
		&i.CorePartner.IsActive,
		&i.CorePartner.Type,
		&i.CorePartner.VatNumber,
		&i.CorePartner.Vat,
		&i.CorePartner.RegistrationNumber,
		&i.CorePartner.PersonalNumber,
		&i.CorePartner.Address,
		&i.CorePartner.Locality,
		&i.CorePartner.CountyCode,
		&i.CorePartner.CreatedAt,
		&i.CoreDocumentPartnerBillingDetail.ID,
		&i.CoreDocumentPartnerBillingDetail.PartnerID,
		&i.CoreDocumentPartnerBillingDetail.Vat,
		&i.CoreDocumentPartnerBillingDetail.RegistrationNumber,
		&i.CoreDocumentPartnerBillingDetail.Address,
		&i.CoreDocumentPartnerBillingDetail.Locality,
		&i.CoreDocumentPartnerBillingDetail.CountyCode,
		&i.CoreDocumentPartnerBillingDetail.CreatedAt,
	)
	return i, err
}

const getDocumentItems = `-- name: GetDocumentItems :many
select
    d_id,
    item_id,
    i.code as item_code,
    i.name as item_name,
    quantity,
    um.id as um_id,
    um.name as um_name,
    um.code AS um_code,
    price,
    vat.id as vat_id,
    vat.name as vat_name,
    vat.percent as vat_percent,
    vat.exemption_reason AS vat_exemption_reason,
    vat.exemption_reason_code AS vat_exemption_reason_code,
    net_value,
    vat_value,
    gros_value,
    item_type_pn
from core.document_details d
         inner join core.items i
                    on i.id=d.item_id
         inner join core.item_vat vat
                    on vat.id=i.id_vat
         inner join core.item_um um
                    on um.id=i.id_um
where h_id=$1
`

type GetDocumentItemsRow struct {
	DID                    uuid.UUID
	ItemID                 uuid.UUID
	ItemCode               sql.NullString
	ItemName               string
	Quantity               float64
	UmID                   int32
	UmName                 string
	UmCode                 string
	Price                  sql.NullFloat64
	VatID                  int32
	VatName                string
	VatPercent             float64
	VatExemptionReason     sql.NullString
	VatExemptionReasonCode sql.NullString
	NetValue               sql.NullFloat64
	VatValue               sql.NullFloat64
	GrosValue              sql.NullFloat64
	ItemTypePn             sql.NullString
}

func (q *Queries) GetDocumentItems(ctx context.Context, hID uuid.UUID) ([]GetDocumentItemsRow, error) {
	rows, err := q.db.Query(ctx, getDocumentItems, hID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetDocumentItemsRow
	for rows.Next() {
		var i GetDocumentItemsRow
		if err := rows.Scan(
			&i.DID,
			&i.ItemID,
			&i.ItemCode,
			&i.ItemName,
			&i.Quantity,
			&i.UmID,
			&i.UmName,
			&i.UmCode,
			&i.Price,
			&i.VatID,
			&i.VatName,
			&i.VatPercent,
			&i.VatExemptionReason,
			&i.VatExemptionReasonCode,
			&i.NetValue,
			&i.VatValue,
			&i.GrosValue,
			&i.ItemTypePn,
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

const getDocumentTransactions = `-- name: GetDocumentTransactions :many
SELECT id,
       name,
       document_type_source_id,
       document_type_destination_id
from core.document_transactions
`

func (q *Queries) GetDocumentTransactions(ctx context.Context) ([]CoreDocumentTransaction, error) {
	rows, err := q.db.Query(ctx, getDocumentTransactions)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []CoreDocumentTransaction
	for rows.Next() {
		var i CoreDocumentTransaction
		if err := rows.Scan(
			&i.ID,
			&i.Name,
			&i.DocumentTypeSourceID,
			&i.DocumentTypeDestinationID,
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

const getDocuments = `-- name: GetDocuments :many
Select
    h_id,
    series,
    number,
    date,
    due_date,
    pa.name as partner,
    is_deleted,
    status
from core.document_header as d
left join core.partners as pa
on pa.id=d.partner_id
where document_type=$1 and date>=$2 and date<=$3  and (($4::uuid[]) IS NULL OR cardinality($4::uuid[]) = 0 OR  pa.id = ANY($4::uuid[]))
ORDER BY date DESC
`

type GetDocumentsParams struct {
	DocumentType int32
	StartDate    time.Time
	EndDate      time.Time
	Partner      []uuid.UUID
}

type GetDocumentsRow struct {
	HID       uuid.UUID
	Series    sql.NullString
	Number    string
	Date      time.Time
	DueDate   sql.NullTime
	Partner   sql.NullString
	IsDeleted bool
	Status    sql.NullString
}

func (q *Queries) GetDocuments(ctx context.Context, arg GetDocumentsParams) ([]GetDocumentsRow, error) {
	rows, err := q.db.Query(ctx, getDocuments,
		arg.DocumentType,
		arg.StartDate,
		arg.EndDate,
		arg.Partner,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetDocumentsRow
	for rows.Next() {
		var i GetDocumentsRow
		if err := rows.Scan(
			&i.HID,
			&i.Series,
			&i.Number,
			&i.Date,
			&i.DueDate,
			&i.Partner,
			&i.IsDeleted,
			&i.Status,
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

const getEfacturaDocument = `-- name: GetEfacturaDocument :one
SELECT d.e_id,
    d.h_id,
    d.x_id,
    x.invoice_xml,
    x.invoice_md5_sum,
    d.status,
    d.upload_index,
    d.download_id,
    d.u_id AS upload_record_id
FROM core.efactura_documents d
INNER JOIN core.efactura_xml_documents x
ON d.x_id = x.id
WHERE d.e_id=$1
`

type GetEfacturaDocumentRow struct {
	EID            uuid.UUID
	HID            uuid.UUID
	XID            int64
	InvoiceXml     string
	InvoiceMd5Sum  string
	Status         CoreEfacturaDocumentStatus
	UploadIndex    sql.NullInt64
	DownloadID     sql.NullInt64
	UploadRecordID sql.NullInt64
}

func (q *Queries) GetEfacturaDocument(ctx context.Context, eID uuid.UUID) (GetEfacturaDocumentRow, error) {
	row := q.db.QueryRow(ctx, getEfacturaDocument, eID)
	var i GetEfacturaDocumentRow
	err := row.Scan(
		&i.EID,
		&i.HID,
		&i.XID,
		&i.InvoiceXml,
		&i.InvoiceMd5Sum,
		&i.Status,
		&i.UploadIndex,
		&i.DownloadID,
		&i.UploadRecordID,
	)
	return i, err
}

const getEfacturaDocumentForHeaderIDLockForUpdate = `-- name: GetEfacturaDocumentForHeaderIDLockForUpdate :one
SELECT d.e_id,
    d.x_id,
    x.invoice_xml,
    x.invoice_md5_sum,
    d.status,
    d.upload_index,
    d.download_id,
    d.u_id AS upload_record_id
FROM core.efactura_documents d
INNER JOIN core.efactura_xml_documents x
ON d.x_id = x.id
WHERE d.h_id=$1
FOR UPDATE OF d
`

type GetEfacturaDocumentForHeaderIDLockForUpdateRow struct {
	EID            uuid.UUID
	XID            int64
	InvoiceXml     string
	InvoiceMd5Sum  string
	Status         CoreEfacturaDocumentStatus
	UploadIndex    sql.NullInt64
	DownloadID     sql.NullInt64
	UploadRecordID sql.NullInt64
}

func (q *Queries) GetEfacturaDocumentForHeaderIDLockForUpdate(ctx context.Context, hID uuid.UUID) (GetEfacturaDocumentForHeaderIDLockForUpdateRow, error) {
	row := q.db.QueryRow(ctx, getEfacturaDocumentForHeaderIDLockForUpdate, hID)
	var i GetEfacturaDocumentForHeaderIDLockForUpdateRow
	err := row.Scan(
		&i.EID,
		&i.XID,
		&i.InvoiceXml,
		&i.InvoiceMd5Sum,
		&i.Status,
		&i.UploadIndex,
		&i.DownloadID,
		&i.UploadRecordID,
	)
	return i, err
}

const getEfacturaDocumentLockForUpdate = `-- name: GetEfacturaDocumentLockForUpdate :one
SELECT d.e_id,
       d.h_id,
       d.x_id,
       x.invoice_xml,
       x.invoice_md5_sum,
       d.status,
       d.upload_index,
       d.download_id,
       d.u_id AS upload_record_id
FROM core.efactura_documents d
INNER JOIN core.efactura_xml_documents x
ON d.x_id = x.id
WHERE d.e_id=$1
FOR UPDATE OF d
`

type GetEfacturaDocumentLockForUpdateRow struct {
	EID            uuid.UUID
	HID            uuid.UUID
	XID            int64
	InvoiceXml     string
	InvoiceMd5Sum  string
	Status         CoreEfacturaDocumentStatus
	UploadIndex    sql.NullInt64
	DownloadID     sql.NullInt64
	UploadRecordID sql.NullInt64
}

func (q *Queries) GetEfacturaDocumentLockForUpdate(ctx context.Context, eID uuid.UUID) (GetEfacturaDocumentLockForUpdateRow, error) {
	row := q.db.QueryRow(ctx, getEfacturaDocumentLockForUpdate, eID)
	var i GetEfacturaDocumentLockForUpdateRow
	err := row.Scan(
		&i.EID,
		&i.HID,
		&i.XID,
		&i.InvoiceXml,
		&i.InvoiceMd5Sum,
		&i.Status,
		&i.UploadIndex,
		&i.DownloadID,
		&i.UploadRecordID,
	)
	return i, err
}

const getGenerateAvailableItems = `-- name: GetGenerateAvailableItems :many
SELECT h_id::UUID, d_id::UUID, number::text, date::date, item_id::UUID, item_code::text, item_name::text,  quantity::float, um_id::INTEGER, um_name::text, vat_id::INTEGER, vat_name::text,vat_percent::float  FROM core.get_generate_available_items($1::uuid, $2::date, $3::int)
`

type GetGenerateAvailableItemsParams struct {
	Partners      uuid.UUID
	Date          time.Time
	TransactionID int32
}

type GetGenerateAvailableItemsRow struct {
	HID        uuid.UUID
	DID        uuid.UUID
	Number     string
	Date       time.Time
	ItemID     uuid.UUID
	ItemCode   string
	ItemName   string
	Quantity   float64
	UmID       int32
	UmName     string
	VatID      int32
	VatName    string
	VatPercent float64
}

func (q *Queries) GetGenerateAvailableItems(ctx context.Context, arg GetGenerateAvailableItemsParams) ([]GetGenerateAvailableItemsRow, error) {
	rows, err := q.db.Query(ctx, getGenerateAvailableItems, arg.Partners, arg.Date, arg.TransactionID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetGenerateAvailableItemsRow
	for rows.Next() {
		var i GetGenerateAvailableItemsRow
		if err := rows.Scan(
			&i.HID,
			&i.DID,
			&i.Number,
			&i.Date,
			&i.ItemID,
			&i.ItemCode,
			&i.ItemName,
			&i.Quantity,
			&i.UmID,
			&i.UmName,
			&i.VatID,
			&i.VatName,
			&i.VatPercent,
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

const getGeneratedDocuments = `-- name: GetGeneratedDocuments :many
select dh.h_id as h_id, dt.name_ro as document_type, dh.number as document_number, dhSource.number as document_source_number from core.document_connections dc
inner join core.document_header dh on dh.h_id=dc.h_id
inner join core.document_header dhSource on dhSource.h_id=dc.h_id_source
inner join core.document_types dt on dt.id=dh.document_type
where h_id_source=$1 and dh.is_deleted=false group by dh.h_id, dt.name_ro,dh.document_type,dhSource.number
`

type GetGeneratedDocumentsRow struct {
	HID                  uuid.UUID
	DocumentType         string
	DocumentNumber       string
	DocumentSourceNumber string
}

func (q *Queries) GetGeneratedDocuments(ctx context.Context, hIDSource uuid.UUID) ([]GetGeneratedDocumentsRow, error) {
	rows, err := q.db.Query(ctx, getGeneratedDocuments, hIDSource)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetGeneratedDocumentsRow
	for rows.Next() {
		var i GetGeneratedDocumentsRow
		if err := rows.Scan(
			&i.HID,
			&i.DocumentType,
			&i.DocumentNumber,
			&i.DocumentSourceNumber,
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

const removeDocumentConnections = `-- name: RemoveDocumentConnections :exec
delete from core.document_connections where  h_id=$1
`

func (q *Queries) RemoveDocumentConnections(ctx context.Context, hID uuid.UUID) error {
	_, err := q.db.Exec(ctx, removeDocumentConnections, hID)
	return err
}

const saveDocument = `-- name: SaveDocument :one
insert into core.document_header(document_type, series, number,partner_id,date,representative_id,recipe_id,notes) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
    RETURNING h_id
`

type SaveDocumentParams struct {
	DocumentType     int32
	Series           sql.NullString
	Number           string
	PartnerID        uuid.UUID
	Date             time.Time
	RepresentativeID uuid.NullUUID
	RecipeID         sql.NullInt32
	Notes            sql.NullString
}

func (q *Queries) SaveDocument(ctx context.Context, arg SaveDocumentParams) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, saveDocument,
		arg.DocumentType,
		arg.Series,
		arg.Number,
		arg.PartnerID,
		arg.Date,
		arg.RepresentativeID,
		arg.RecipeID,
		arg.Notes,
	)
	var h_id uuid.UUID
	err := row.Scan(&h_id)
	return h_id, err
}

const saveDocumentConnection = `-- name: SaveDocumentConnection :exec
SELECT core.insert_document_connections(
$1::int,
$2::uuid,
$3::uuid,
$4::uuid,
$5::uuid,
$6::uuid,
$7::float
)
`

type SaveDocumentConnectionParams struct {
	TransactionID int32
	HID           uuid.UUID
	DID           uuid.UUID
	HIDSource     uuid.UUID
	DIDSource     uuid.UUID
	ItemID        uuid.UUID
	Quantity      float64
}

func (q *Queries) SaveDocumentConnection(ctx context.Context, arg SaveDocumentConnectionParams) error {
	_, err := q.db.Exec(ctx, saveDocumentConnection,
		arg.TransactionID,
		arg.HID,
		arg.DID,
		arg.HIDSource,
		arg.DIDSource,
		arg.ItemID,
		arg.Quantity,
	)
	return err
}

const saveDocumentDetails = `-- name: SaveDocumentDetails :one
SELECT returned_d_id::UUID from core.insert_document_details(
    $1::uuid,
    $2::uuid,
    $3::float,
    $4::float,
    $5::float,
    $6::float,
    $7::float,
    $8::text
) AS returned_d_id
`

type SaveDocumentDetailsParams struct {
	HID        uuid.UUID
	ItemID     uuid.UUID
	Quantity   float64
	Price      sql.NullFloat64
	NetValue   sql.NullFloat64
	VatValue   sql.NullFloat64
	GrossValue sql.NullFloat64
	ItemTypePn sql.NullString
}

func (q *Queries) SaveDocumentDetails(ctx context.Context, arg SaveDocumentDetailsParams) (uuid.UUID, error) {
	row := q.db.QueryRow(ctx, saveDocumentDetails,
		arg.HID,
		arg.ItemID,
		arg.Quantity,
		arg.Price,
		arg.NetValue,
		arg.VatValue,
		arg.GrossValue,
		arg.ItemTypePn,
	)
	var returned_d_id uuid.UUID
	err := row.Scan(&returned_d_id)
	return returned_d_id, err
}

const updateAuthorizationCode = `-- name: UpdateAuthorizationCode :exec
UPDATE core.efactura_authorizations
SET status='code_received',
    code=$2,
    updated_at=NOW()
WHERE a_id=$1
`

type UpdateAuthorizationCodeParams struct {
	AID  uuid.UUID
	Code sql.NullString
}

func (q *Queries) UpdateAuthorizationCode(ctx context.Context, arg UpdateAuthorizationCodeParams) error {
	_, err := q.db.Exec(ctx, updateAuthorizationCode, arg.AID, arg.Code)
	return err
}

const updateAuthorizationStatus = `-- name: UpdateAuthorizationStatus :exec
UPDATE core.efactura_authorizations
SET status=$2,
    updated_at=NOW()
WHERE a_id=$1
`

type UpdateAuthorizationStatusParams struct {
	AID    uuid.UUID
	Status CoreEfacturaAuthorizationStatus
}

func (q *Queries) UpdateAuthorizationStatus(ctx context.Context, arg UpdateAuthorizationStatusParams) error {
	_, err := q.db.Exec(ctx, updateAuthorizationStatus, arg.AID, arg.Status)
	return err
}

const updateAuthorizationToken = `-- name: UpdateAuthorizationToken :exec
UPDATE core.efactura_authorizations
SET status='success',
    token=$2,
    token_expires_at=$3,
    updated_at=NOW()
WHERE a_id=$1
`

type UpdateAuthorizationTokenParams struct {
	AID            uuid.UUID
	Token          pgtype.JSON
	TokenExpiresAt sql.NullTime
}

func (q *Queries) UpdateAuthorizationToken(ctx context.Context, arg UpdateAuthorizationTokenParams) error {
	_, err := q.db.Exec(ctx, updateAuthorizationToken, arg.AID, arg.Token, arg.TokenExpiresAt)
	return err
}

const updateEfacturaDocumentXMLDocumentID = `-- name: UpdateEfacturaDocumentXMLDocumentID :exec
UPDATE core.efactura_documents
SET x_id=$2,
    updated_at=NOW()
WHERE e_id=$1
`

type UpdateEfacturaDocumentXMLDocumentIDParams struct {
	EID uuid.UUID
	XID int64
}

func (q *Queries) UpdateEfacturaDocumentXMLDocumentID(ctx context.Context, arg UpdateEfacturaDocumentXMLDocumentIDParams) error {
	_, err := q.db.Exec(ctx, updateEfacturaDocumentXMLDocumentID, arg.EID, arg.XID)
	return err
}

const updateEfacturaUploadIndex = `-- name: UpdateEfacturaUploadIndex :exec
WITH update_upload AS (
    UPDATE core.efactura_document_uploads
    SET upload_index=$2,
        status='processing',
        updated_at=NOW()
    WHERE id=$1
    RETURNING id
)
UPDATE core.efactura_documents
SET upload_index=$2,
    status='processing',
    updated_at=NOW()
WHERE u_id = (SELECT id FROM update_upload)
`

type UpdateEfacturaUploadIndexParams struct {
	ID          int64
	UploadIndex sql.NullInt64
}

func (q *Queries) UpdateEfacturaUploadIndex(ctx context.Context, arg UpdateEfacturaUploadIndexParams) error {
	_, err := q.db.Exec(ctx, updateEfacturaUploadIndex, arg.ID, arg.UploadIndex)
	return err
}

const updateEfacturaUploadStatus = `-- name: UpdateEfacturaUploadStatus :exec
WITH update_upload AS (
    UPDATE core.efactura_document_uploads
    SET status=$2,
        download_id=$3,
        updated_at=NOW()
    WHERE id=$1
    RETURNING id
)
UPDATE core.efactura_documents
SET status=$2,
    download_id=$3,
    updated_at=NOW()
WHERE u_id = (SELECT id FROM update_upload)
`

type UpdateEfacturaUploadStatusParams struct {
	ID         int64
	Status     CoreEfacturaDocumentStatus
	DownloadID sql.NullInt64
}

func (q *Queries) UpdateEfacturaUploadStatus(ctx context.Context, arg UpdateEfacturaUploadStatusParams) error {
	_, err := q.db.Exec(ctx, updateEfacturaUploadStatus, arg.ID, arg.Status, arg.DownloadID)
	return err
}
