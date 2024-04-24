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
