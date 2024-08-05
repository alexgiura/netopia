package models

type Partner struct {
	ID                 string   `json:"id"`
	Code               *string  `json:"code"`
	Type               string   `json:"type"`
	Active             bool     `json:"active"`
	Name               string   `json:"name"`
	VatNumber          *string  `json:"vat_number"`
	Vat                bool     `json:"vat"`
	RegistrationNumber *string  `json:"registration_number"`
	Address            *Address `json:"company_address"`
}

const (
	CompanyType    = "Persoana Juridica"
	IndividualType = "Persoana Fizica"
)
