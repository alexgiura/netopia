package models

type Um struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Code string `json:"code"`
}

type Vat struct {
	ID                  int     `json:"id"`
	Name                string  `json:"name"`
	Percent             float64 `json:"percent"`
	ExemptionReason     *string `json:"exemption_reason,omitempty"`
	ExemptionReasonCode *string `json:"exemption_reason_code,omitempty"`
	IsActive            bool    `json:"is_active"`
}

type ItemCategory struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	IsActive   bool   `json:"is_active"`
	GeneratePn bool   `json:"generate_pn"`
}

type Item struct {
	ID       string        `json:"id"`
	Code     *string       `json:"code,omitempty"`
	Name     string        `json:"name"`
	IsActive bool          `json:"is_active"`
	IsStock  bool          `json:"is_stock"`
	Um       Um            `json:"um"`
	Vat      Vat           `json:"vat"`
	Category *ItemCategory `json:"category,omitempty"`
}
