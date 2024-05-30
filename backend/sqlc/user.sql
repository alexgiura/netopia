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
    phone_number::text;

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

