-- name: GetPartners :many
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
where (sqlc.arg(partnerId)::uuid)='00000000-0000-0000-0000-000000000000' OR id=(sqlc.arg(partnerId)::uuid);


-- name: InsertPartner :one
Insert into core.partners (code,name,type,vat,vat_number,registration_number,address,locality,county_code,bank,iban)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
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
    county_code=$11,
    bank=$12,
    iban=$13
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

