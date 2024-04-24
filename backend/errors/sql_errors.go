package errors

import "github.com/google/uuid"

var (
	Codes_Duplicate_Key = "23505"

	ResultNoRows = "no rows in result set"

	BlankUUID = uuid.MustParse("00000000-0000-0000-0000-000000000000")
)
