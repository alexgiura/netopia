-- name: GetPartners :many
select
    id,
    code,
    name,
    type,
    vat,
    vat_number,
    registration_number,
    is_active
from core.partners;
-- where  (code like ('%' || sqlc.arg(code) || '%') OR code IS NULL) and name like '%' || sqlc.arg(name) || '%' and type like '%' || sqlc.arg(type)|| '%' and tax_id like '%' || sqlc.arg(tax_id)|| '%';

-- name: InsertPartner :one
Insert into core.partners (code,name,type,vat,vat_number,registration_number,address,locality,county_code)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
RETURNING id;

-- name: UpdatePartner :exec
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
    county_code=$11
where id=$1;

-- name: GetPartnersByDocumentIds :many
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
        d.h_id = ANY($1::uuid[]);

