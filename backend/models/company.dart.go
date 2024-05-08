package models

type Company struct {
	Name               string `json:"name"`
	VatNumber          string `json:"vat_number_id"`
	RegistrationNumber string `json:"registration_number"`
}
