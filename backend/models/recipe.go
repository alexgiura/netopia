package models

type Recipe struct {
	Id       string `json:"id"`
	Name     string `json:"name"`
	IsActive bool   `json:"is_active"`
}

//type RecipeItem struct {
//	Id          string   `json:"id"`
//	Item        Item     `json:"item"`
//	Quantity    float64  `json:"quantity"`
//	Price       *float64 `json:"price"`
//	AmountNet   *float64 `json:"amount_net"`
//	AmountVat   *float64 `json:"amount_vat"`
//	AmountGross *float64 `json:"amount_gross"`
//	ItemTypePn  *string  `json:"item_type_pn,omitempty"`
//}
