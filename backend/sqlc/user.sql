-- name: UserExists :one
SELECT EXISTS(
               SELECT 1
               FROM core.users
               WHERE id = $1
           ) AS exists;

-- name: GetUserById :one
SELECT id,
       phone_number,
       user_type,
       name,
       device_id,
       email
from core.users
WHERE id = $1
LIMIT 1;

-- name: SaveUser :one
INSERT INTO core.users(id,phone_number,name,user_type,email,device_id)
values ($1,$2,$3,$4,$5,$6)
RETURNING id;

-- name: UpdateUser :one
Update core.users
SET
    name = $2,
    email = $3
where id=$1
RETURNING
    id::text,
    phone_number::text,
    user_type::text,
    name::text,
    email::text,
    device_id::text;
