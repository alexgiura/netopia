package models

type Partner struct {
<<<<<<< HEAD
	ID      string   `json:"id"`
	Code    string   `json:"code"`
	Type    string   `json:"type"`
	Active  bool     `json:"active"`
	Company *Company `json:"company"`
}
=======
	ID                 string   `json:"id"`
	Code               *string  `json:"code"`
	Type               string   `json:"type"`
	Active             bool     `json:"active"`
	Name               string   `json:"name"`
	VatNumber          *string  `json:"vat_number"`
	Vat                bool     `json:"vat"`
	RegistrationNumber *string  `json:"registration_number"`
	IndividualNumber   *string  `json:"individual_number"`
	Address            *Address `json:"company_address"`
	//Company            *Company    `json:"company"`
	//Individual         *Individual `json:"company"`
}

type Company struct {
	Name               string   `json:"name"`
	VatNumber          *string  `json:"vat_number"`
	Vat                bool     `json:"vat"`
	RegistrationNumber *string  `json:"registration_number"`
	CompanyAddress     *Address `json:"company_address"`
}

type Individual struct {
	Name              string   `json:"name"`
	IndividualNumber  *string  `json:"individual_number"`
	IndividualAddress *Address `json:"individual_address"`
}

const (
	CompanyType    = "Persoana Juridica"
	IndividualType = "Persoana Fizica"
)
>>>>>>> origin/dev
