-- name: GetPartners :many
select
    id,
    code,
    name,
    type,
    vat_number,
    registration_number,
    personal_id,
    is_active
from core.partners
where  (code like ('%' || sqlc.arg(code) || '%') OR code IS NULL) and name like '%' || sqlc.arg(name) || '%' and type like '%' || sqlc.arg(type)|| '%' and tax_id like '%' || sqlc.arg(tax_id)|| '%';

-- name: InsertPartner :one
Insert into core.partners (code,name,type,vat_number,registration_number,personal_id)
VALUES ($1,$2,$3,$4,$5,$6)
RETURNING id;

-- name: UpdatePartner :exec
Update core.partners
Set code=$2,
    name=$3,
    is_active=$4,
    type=$5,
    vat_number=$6,
    registration_number=$7,
    personal_id=$8
where id=$1;
