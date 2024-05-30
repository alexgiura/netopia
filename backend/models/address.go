package models

type Address struct {
	Address    *string `json:"address"`
	Locality   *string `json:"locality"`
	CountyCode *string `json:"county_code"`
}
