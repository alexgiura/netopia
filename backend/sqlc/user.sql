-- name: UserExists :one
SELECT EXISTS(
               SELECT 1
               FROM core.users
               WHERE id = $1
           ) AS exists;

-- name: GetUserById :one
SELECT id,
       email,
       phone_number

from core.users
WHERE id = $1
LIMIT 1;

-- name: SaveUser :one
INSERT INTO core.users(id,email,phone_number)
values ($1,$2,$3)
RETURNING
 id::text,
    email::text,
    COALESCE(phone_number, '')::text as phone_number;

-- name: UpdateUser :one
Update core.users
SET
    email = $2,
    phone_number = $3
where id=$1
RETURNING
    id::text,
    email::text,
    phone_number::text;

-- name: GetAuthorization :one
SELECT a_id, token
FROM core.efactura_authorizations ea
WHERE ea.status='success'  and ea.token_expires_at > CURRENT_DATE
ORDER BY ea.token_expires_at DESC LIMIT 1;

