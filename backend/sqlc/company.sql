-- name: GetCompany :one
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
    LIMIT 1;

-- name: GetCompanyByTaxId :one
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
where vat_number=$1
         LIMIT 1;

-- name: SaveCompany :one
INSERT INTO core.company(name,vat,vat_number,registration_number,address, locality,county_code)
values ($1,$2,$3,$4,$5,$6,$7)
    RETURNING
    name::text,
    vat::bool,
    vat_number::text,
    registration_number::text,
    address::text,
    locality::text,
    county_code::text;
