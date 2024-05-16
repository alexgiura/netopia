// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: user.sql

package db

import (
	"context"
	"database/sql"
)

const getUserById = `-- name: GetUserById :one
SELECT id,
       email,
       phone_number

from core.users
WHERE id = $1
LIMIT 1
`

type GetUserByIdRow struct {
	ID          string
	Email       string
	PhoneNumber sql.NullString
}

func (q *Queries) GetUserById(ctx context.Context, id string) (GetUserByIdRow, error) {
	row := q.db.QueryRow(ctx, getUserById, id)
	var i GetUserByIdRow
	err := row.Scan(&i.ID, &i.Email, &i.PhoneNumber)
	return i, err
}

const saveUser = `-- name: SaveUser :one
INSERT INTO core.users(id,email,phone_number)
values ($1,$2,$3)
RETURNING
 id::text,
    email::text,
    phone_number::text
`

type SaveUserParams struct {
	ID          string
	Email       string
	PhoneNumber sql.NullString
}

type SaveUserRow struct {
	ID          string
	Email       string
	PhoneNumber string
}

func (q *Queries) SaveUser(ctx context.Context, arg SaveUserParams) (SaveUserRow, error) {
	row := q.db.QueryRow(ctx, saveUser, arg.ID, arg.Email, arg.PhoneNumber)
	var i SaveUserRow
	err := row.Scan(&i.ID, &i.Email, &i.PhoneNumber)
	return i, err
}

const updateUser = `-- name: UpdateUser :one
Update core.users
SET
    email = $2,
    phone_number = $3
where id=$1
RETURNING
    id::text,
    email::text,
    phone_number::text
`

type UpdateUserParams struct {
	ID          string
	Email       string
	PhoneNumber sql.NullString
}

type UpdateUserRow struct {
	ID          string
	Email       string
	PhoneNumber string
}

func (q *Queries) UpdateUser(ctx context.Context, arg UpdateUserParams) (UpdateUserRow, error) {
	row := q.db.QueryRow(ctx, updateUser, arg.ID, arg.Email, arg.PhoneNumber)
	var i UpdateUserRow
	err := row.Scan(&i.ID, &i.Email, &i.PhoneNumber)
	return i, err
}

const userExists = `-- name: UserExists :one
SELECT EXISTS(
               SELECT 1
               FROM core.users
               WHERE id = $1
           ) AS exists
`

func (q *Queries) UserExists(ctx context.Context, id string) (bool, error) {
	row := q.db.QueryRow(ctx, userExists, id)
	var exists bool
	err := row.Scan(&exists)
	return exists, err
}
