package models

type Document struct {
	HId            string       `json:"h_id"`
	Type           DocumentType `json:"type"`
	Series         *string      `json:"series"`
	Number         string       `json:"number"`
	Date           string       `json:"date"`
	DueDate        *string      `json:"due_date"`
	Deleted        bool         `json:"deleted"`
	EFacturaStatus *string      `json:"efactura_status"`
	Notes          *string      `json:"notes"`
	//DocumentItems []*DocumentItem `json:"document_items"`
	//Person           *Company    `json:"company"`
	//Individual         *Individual `json:"company"`
}

type DocumentItem struct {
	DId         string   `json:"d_id"`
	Item        Item     `json:"item"`
	Quantity    float64  `json:"quantity"`
	Price       *float64 `json:"price"`
	AmountNet   *float64 `json:"amount_net"`
	AmountVat   *float64 `json:"amount_vat"`
	AmountGross *float64 `json:"amount_gross"`
	ItemTypePn  *string  `json:"item_type_pn,omitempty"`
}

type DocumentType struct {
	ID     int    `json:"id"`
	NameRo string `json:"name_ro"`
	NameEn string `json:"name_en"`
}
