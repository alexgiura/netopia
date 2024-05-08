package models

type Partner struct {
	ID     string `json:"id"`
	Code   string `json:"code"`
	Type   string `json:"type"`
	Active bool   `json:"active"`
}
