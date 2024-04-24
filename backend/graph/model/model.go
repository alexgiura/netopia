package model

import (
	"github.com/99designs/gqlgen/graphql"
	"github.com/pkg/errors"
	"github.com/shopspring/decimal"
	"io"
)

func MarshalDecimal(d decimal.Decimal) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		io.WriteString(w, d.String())
	})
}
func UnmarshalDecimal(v interface{}) (decimal.Decimal, error) {
	switch value := v.(type) {
	case string:
		return decimal.NewFromString(value)
	case float64:
		return decimal.NewFromFloat(value), nil
	default:
		return decimal.Decimal{}, errors.New("Decimal must be a string or a float")
	}
}

//func MarshalDecimal(d decimal.Decimal) graphql.Marshaler {
//	return graphql.WriterFunc(func(w io.Writer) {
//		io.WriteString(w, strconv.Quote(fmt.Sprintf("%d", d)))
//	})
//}

//func UnmarshalDecimal(v interface{}) (decimal.Decimal, error) {
//	d, ok := v.(string)
//	if !ok {
//		return decimal.Decimal{}, fmt.Errorf("decimal must be strings")
//	}
//	i, e := decimal.NewFromString(d)
//	return i, e
//
//}
