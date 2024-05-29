package util

import (
	"database/sql"
	"encoding/json"
	"net/url"
	"strconv"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgtype"
)

func NullableStr(str *string) sql.NullString {
	if str == nil {
		return sql.NullString{
			Valid: false,
		}
	} else {
		return sql.NullString{
			Valid:  true,
			String: *str,
		}
	}
}
func ParamStr(str *string) sql.NullString {
	if str == nil {
		return sql.NullString{
			Valid:  true,
			String: "",
		}
	} else {
		return sql.NullString{
			Valid:  true,
			String: *str,
		}
	}
}

func StrToUUID(str *string) uuid.UUID {
	if str == nil {
		return uuid.Nil
	} else {
		v, err := uuid.Parse(*str)
		if err != nil {
			return uuid.Nil
		}
		return v
	}
}

func StrArrayToUuidArray(strArray []string) []uuid.UUID {
	var uuidArray []uuid.UUID
	for _, str := range strArray {
		id, err := uuid.Parse(str)
		if err != nil {
			// Skip invalid UUID strings
			continue
		}
		uuidArray = append(uuidArray, id)
	}
	return uuidArray
}

func IntArrayToInt32Array(intSlice []int) []int32 {
	var int32Slice []int32
	for _, num := range intSlice {
		int32Slice = append(int32Slice, int32(num))
	}
	return int32Slice
}

func NullableUuid(uid uuid.UUID) uuid.NullUUID {
	if uid == uuid.Nil {
		return uuid.NullUUID{
			UUID:  uid,
			Valid: false,
		}
	} else {
		return uuid.NullUUID{
			UUID:  uid,
			Valid: true,
		}
	}
}
func NullableFloat64(f *float64) sql.NullFloat64 {
	if f == nil {
		return sql.NullFloat64{
			Valid: false,
		}
	} else {
		return sql.NullFloat64{
			Valid:   true,
			Float64: *f,
		}
	}
}

func NullableInt32(i *int) sql.NullInt32 {
	if i == nil {
		return sql.NullInt32{
			Valid: false,
		}
	} else {
		return sql.NullInt32{
			Valid: true,
			Int32: int32(*i),
		}
	}
}

func StringOrNil(str sql.NullString) *string {
	if str.Valid {
		return &str.String
	}
	return nil
}

func StringPtr(str string) *string {
	return &str
}

func FloatOrNil(f sql.NullFloat64) *float64 {
	if f.Valid {
		return &f.Float64
	}
	return nil
}

func IntOrNil(i sql.NullInt32) *int {
	if i.Valid {
		new := int(i.Int32)
		return &new
	}
	return nil
}
func Int32OrNil(i *int) *int32 {
	if i == nil {
		return nil
	}
	result := int32(*i)
	return &result
}

func BoolOrNil(i sql.NullBool) *bool {
	if i.Valid {
		return &i.Bool
	}
	return nil
}

func IntToString(i int64) *string {
	str := strconv.FormatInt(i, 10)
	return &str
}

func Int32ToString(i int32) *string {
	str := strconv.FormatInt(int64(i), 10)
	return &str
}

func NullUuidToString(uuidVal uuid.NullUUID) *string {
	if uuidVal.Valid {
		strVal := uuidVal.UUID.String()
		return &strVal
	}
	return nil
}

func NullableTime(t *time.Time) sql.NullTime {
	if t == nil {
		return sql.NullTime{
			Valid: false,
		}
	} else {
		return sql.NullTime{
			Valid: true,
			Time:  *t,
		}
	}
}

func AddGetParams(u string, q url.Values) (string, error) {
	pu, err := url.Parse(u)
	if err != nil {
		return "", err
	}

	pq := pu.Query()
	for k, v := range q {
		pq[k] = v
	}

	pu.RawQuery = pq.Encode()
	return pu.String(), nil
}

func BytesToPgtypeJSON(b []byte) pgtype.JSON {
	return pgtype.JSON{
		Bytes:  b,
		Status: pgtype.Present,
	}
}

func MarshalToPgtypeJSON(v any) pgtype.JSON {
	var pgjson pgtype.JSON
	b, err := json.Marshal(v)
	if err != nil {
		return pgjson
	}
	return BytesToPgtypeJSON(b)
}

func NullableInt64(i *int64) sql.NullInt64 {
	if i == nil {
		return sql.NullInt64{}
	}
	return sql.NullInt64{
		Valid: true,
		Int64: *i,
	}
}
