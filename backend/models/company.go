package models

type Company struct {
	Id                 string   `json:"id"`
	Name               string   `json:"name"`
	VatNumber          *string  `json:"vat_number"`
	Vat                bool     `json:"vat"`
	RegistrationNumber *string  `json:"registration_number"`
	CompanyAddress     *Address `json:"company_address"`
}
