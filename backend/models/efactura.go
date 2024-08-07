package models

type EFactura struct {
	Status       *string `json:"status"`
	ErrorMessage *string `json:"error_message"`
}
