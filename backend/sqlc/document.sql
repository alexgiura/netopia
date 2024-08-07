-- name: GetDocuments :many
Select
    d.h_id,
    dt.id as document_type_id,
    dt.name_ro as document_type_name_ro,
    dt.name_en as document_type_name_en,
    series,
    number,
    date,
    due_date,
    pa.name as partner,
    is_deleted,
    ed.status as efactura_status,
    ed.error_message as efactura_error_message,
    notes
from core.document_header as d
    left join core.partners as pa
on pa.id=d.partner_id
    left join core.document_types as dt
    on dt.id=d.document_type
    left join core.efactura_documents ed
    on ed.h_id=d.h_id
where document_type=$1 and date>=sqlc.arg(start_date) and date<=sqlc.arg(end_date)  and ((sqlc.arg(partner)::uuid[]) IS NULL OR cardinality(sqlc.arg(partner)::uuid[]) = 0 OR  pa.id = ANY(sqlc.arg(partner)::uuid[]))
ORDER BY date DESC;


-- name: GetDocumentHeader :one
Select
    d.h_id,
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
    is_deleted,
    ed.status as efactura_status,
    ed.error_message as efactura_error_message
from core.document_header as d
    left join core.partners as pa
on pa.id=d.partner_id
    left join core.persons as pe
    on pe.id=d.representative_id
    left join core.document_types as dt
    on dt.id=d.document_type
    left join core.document_currency dc
    on d.currency_id = dc.id
    left join core.efactura_documents ed
    on ed.h_id=d.h_id
where d.h_id=$1;

-- name: GetDocumentHeaderPartner :one
Select
    id,
    code,
    name,
    is_active,
    type,
    vat,
    vat_number,
    registration_number,
    address,
    locality,
    county_code
from core.partners
where id=$1;

-- name: GetDocumentItems :many
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
where h_id=$1;

-- name: GetDocumentItemsByDocumentIds :many
SELECT
    h_id,
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
FROM
    core.document_details d
        inner join core.items i
                   on i.id=d.item_id
        inner join core.item_vat vat
                   on vat.id=i.id_vat
        inner join core.item_um um
                   on um.id=i.id_um

WHERE
        h_id = ANY($1::uuid[]);


-- name: SaveDocument :one
insert into core.document_header(document_type, series, number,partner_id,date,representative_id,recipe_id,notes,currency_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
    RETURNING h_id;


-- name: SaveDocumentDetails :one
SELECT returned_d_id::UUID from core.insert_document_details(
                                        sqlc.arg('h_id')::uuid,
                                        sqlc.arg('item_id')::uuid,
                                        sqlc.arg('quantity')::float,
                                        sqlc.narg('price')::float,
                                        sqlc.narg('net_value')::float,
                                        sqlc.narg('vat_value')::float,
                                        sqlc.narg('gross_value')::float,
                                        sqlc.narg('item_type_pn')::text
                                    ) AS returned_d_id;


-- name: GetDocumentTransactions :many
SELECT id,
       name,
       document_type_source_id,
       document_type_destination_id
from core.document_transactions;




-- name: GetGenerateAvailableItems :many
SELECT h_id::UUID, d_id::UUID, number::text, date::date, item_id::UUID, item_code::text, item_name::text,  quantity::float, um_id::INTEGER, um_name::text, vat_id::INTEGER, vat_name::text,vat_percent::float  FROM core.get_generate_available_items(sqlc.arg('partners')::uuid, sqlc.arg('date')::date, sqlc.arg('transaction_id')::int);

-- name: GetDocumentDetails :one
SELECT quantity::float,h_id,d_id from core.document_details where d_id=$1;

-- name: SaveDocumentConnection :exec
SELECT core.insert_document_connections(
               sqlc.arg('transaction_id')::int,
               sqlc.arg('h_id')::uuid,
               sqlc.arg('d_id')::uuid,
               sqlc.arg('h_id_source')::uuid,
               sqlc.arg('d_id_source')::uuid,
               sqlc.arg('item_id')::uuid,
               sqlc.arg('quantity')::float
           );

-- name: GetGeneratedDocuments :many
select dh.h_id as h_id, dt.name_ro as document_type, dh.number as document_number, dhSource.number as document_source_number from core.document_connections dc
                                                                                                                                      inner join core.document_header dh on dh.h_id=dc.h_id
                                                                                                                                      inner join core.document_header dhSource on dhSource.h_id=dc.h_id_source
                                                                                                                                      inner join core.document_types dt on dt.id=dh.document_type
where h_id_source=$1 and dh.is_deleted=false group by dh.h_id, dt.name_ro,dh.document_type,dhSource.number;

-- name: DeleteDocument :exec
Update core.document_header
Set is_deleted=true
where h_id=$1;


-- name: RemoveDocumentConnections :exec
delete from core.document_connections where  h_id=$1;


-- name: GetCurrencyList :many
select id, name from core.document_currency;

-- name: GetDocumentHeaderPartnerBillingDetails :one
SELECT sqlc.embed(p), sqlc.embed(bd)
FROM core.document_partner_billing_details bd
         INNER JOIN core.partners p
                    ON p.id = bd.partner_id
WHERE bd.id=$1;

-- name: GenerateAuthorization :one
INSERT INTO core.efactura_authorizations(company_id) SELECT id FROM core.company LIMIT 1
    RETURNING a_id;

-- name: CloneAuthorizationWithToken :one
WITH auth AS (
    SELECT company_id, code, status FROM core.efactura_authorizations
    WHERE efactura_authorizations.a_id=$1
)
INSERT INTO core.efactura_authorizations(company_id, code, status, token, token_expires_at)
SELECT auth.company_id, auth.code, auth.status, $2, $3 FROM auth
                                                                RETURNING a_id;

-- name: UpdateAuthorizationCode :exec
UPDATE core.efactura_authorizations
SET status='code_received',
    code=$2,
    updated_at=NOW()
WHERE a_id=$1;

-- name: UpdateAuthorizationStatus :exec
UPDATE core.efactura_authorizations
SET status=$2,
    updated_at=NOW()
WHERE a_id=$1;

-- name: UpdateAuthorizationToken :exec
UPDATE core.efactura_authorizations
SET status='success',
    token=$2,
    token_expires_at=$3,
    updated_at=NOW()
WHERE a_id=$1;

-- name: FetchLastAuthorization :one
SELECT a_id, token
FROM core.efactura_authorizations ea
         INNER JOIN core.company c ON ea.company_id = c.id
WHERE ea.status='success'
ORDER BY ea.token_expires_at DESC LIMIT 1;

-- name: CreateEfacturaXMLDocument :one
INSERT INTO core.efactura_xml_documents(h_id, invoice_xml, invoice_md5_sum)
VALUES ($1,$2,$3) RETURNING id;

-- name: CreateEfacturaDocument :one
INSERT INTO core.efactura_documents(h_id, x_id, status)
VALUES ($1,$2,$3) RETURNING e_id;

--- name: UpdateEfacturaDocumentStatus :exec
UPDATE core.efactura_documents
SET status=$2,
    updated_at=NOW()
WHERE e_id=$1;

-- name: UpdateEfacturaDocumentXMLDocumentID :exec
UPDATE core.efactura_documents
SET x_id=$2,
    updated_at=NOW()
WHERE e_id=$1;

-- name: CreateEfacturaDocumentUpload :one
WITH insert_upload AS (
INSERT INTO core.efactura_document_uploads(e_id, x_id, status, upload_index, error_message)
VALUES ($1, $2, $3, $4, $5)
    RETURNING id
    )
UPDATE core.efactura_documents AS ed
SET x_id=$2,
    status=$3,
    upload_index=$4,
    error_message=$5,
    u_id = (SELECT id FROM insert_upload)
WHERE ed.e_id=$1
    RETURNING u_id::bigint;

-- name: UpdateEfacturaUploadIndex :exec
WITH update_upload AS (
UPDATE core.efactura_document_uploads
SET upload_index=$2,
    status='processing',
    error_message=NULL,
    updated_at=NOW()
WHERE id=$1
    RETURNING id
)
UPDATE core.efactura_documents
SET upload_index=$2,
    status='processing',
    error_message=NULL,
    updated_at=NOW()
WHERE u_id = (SELECT id FROM update_upload);

-- name: UpdateEfacturaUploadStatus :exec
WITH update_upload AS (
UPDATE core.efactura_document_uploads
SET status=$2,
    download_id=$3,
    error_message=$4,
    updated_at=NOW()
WHERE id=$1
    RETURNING id
)
UPDATE core.efactura_documents
SET status=$2,
    download_id=$3,
    error_message=$4,
    updated_at=NOW()
WHERE u_id = (SELECT id FROM update_upload);

-- name: GetEfacturaDocument :one
SELECT d.e_id,
       d.h_id,
       d.x_id,
       x.invoice_xml,
       x.invoice_md5_sum,
       d.status,
       d.upload_index,
       d.download_id,
       d.error_message,
       d.u_id AS upload_record_id
FROM core.efactura_documents d
         INNER JOIN core.efactura_xml_documents x
                    ON d.x_id = x.id
WHERE d.e_id=$1;

-- name: GetEfacturaDocumentLockForUpdate :one
SELECT d.e_id,
       d.h_id,
       d.x_id,
       x.invoice_xml,
       x.invoice_md5_sum,
       d.status,
       d.upload_index,
       d.download_id,
       d.error_message,
       d.u_id AS upload_record_id
FROM core.efactura_documents d
         INNER JOIN core.efactura_xml_documents x
                    ON d.x_id = x.id
WHERE d.e_id=$1
    FOR UPDATE OF d;

-- name: GetEfacturaDocumentForHeaderIDLockForUpdate :one
SELECT d.e_id,
       d.x_id,
       x.invoice_xml,
       x.invoice_md5_sum,
       d.status,
       d.upload_index,
       d.download_id,
       d.error_message,
       d.u_id AS upload_record_id
FROM core.efactura_documents d
         INNER JOIN core.efactura_xml_documents x
                    ON d.x_id = x.id
WHERE d.h_id=$1
    FOR UPDATE OF d;