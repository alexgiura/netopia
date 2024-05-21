package models

type Address struct {
<<<<<<< HEAD
	Address    string `json:"address"`
	Locality   string `json:"locality"`
	CountyCode string `json:"county_code"`
=======
	Address    *string `json:"address"`
	Locality   *string `json:"locality"`
	CountyCode *string `json:"county_code"`
>>>>>>> origin/dev
}
