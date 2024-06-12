// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package model

import (
	"backend/models"
	"fmt"
	"io"
	"strconv"
)

type AddressInput struct {
	Address    *string `json:"address,omitempty"`
	Locality   *string `json:"locality,omitempty"`
	CountyCode *string `json:"county_code,omitempty"`
}

type ChartData struct {
	X       string   `json:"x"`
	Y       float64  `json:"y"`
	SecondY *float64 `json:"second_y,omitempty"`
}

type CompanyInput struct {
	Name               string        `json:"name"`
	VatNumber          string        `json:"vat_number"`
	Vat                bool          `json:"vat"`
	RegistrationNumber *string       `json:"registration_number,omitempty"`
	CompanyAddress     *AddressInput `json:"company_address,omitempty"`
}

type Currency struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type DeleteDocumentInput struct {
	HID             string `json:"h_id"`
	DeleteGenerated bool   `json:"delete_generated"`
}

type DocumentInput struct {
	DocumentType  int                  `json:"document_type"`
	Series        *string              `json:"series,omitempty"`
	Number        string               `json:"number"`
	Date          string               `json:"date"`
	DueDate       *string              `json:"due_date,omitempty"`
	PartnerID     string               `json:"partner_id"`
	PersonID      *string              `json:"person_id,omitempty"`
	RecipeID      *int                 `json:"recipe_id,omitempty"`
	Notes         *string              `json:"notes,omitempty"`
	TransactionID *int                 `json:"transaction_id,omitempty"`
	DocumentItems []*DocumentItemInput `json:"document_items"`
}

type DocumentItemInput struct {
	ItemID       string   `json:"item_id"`
	Quantity     float64  `json:"quantity"`
	ItemName     *string  `json:"item_name,omitempty"`
	Price        *float64 `json:"price,omitempty"`
	AmountNet    *float64 `json:"amount_net,omitempty"`
	AmountVat    *float64 `json:"amount_vat,omitempty"`
	AmountGross  *float64 `json:"amount_gross,omitempty"`
	GeneratedDID []string `json:"generated_d_id,omitempty"`
	ItemTypePn   *string  `json:"item_type_pn,omitempty"`
}

type DocumentTransaction struct {
	ID                        int    `json:"id"`
	Name                      string `json:"name"`
	DocumentTypeSourceID      int    `json:"document_type_source_id"`
	DocumentTypeDestinationID int    `json:"document_type_destination_id"`
}

type GenerateAvailableItems struct {
	HID          string               `json:"h_id"`
	Series       *string              `json:"series,omitempty"`
	Number       string               `json:"number"`
	Date         string               `json:"date"`
	PartnerID    *string              `json:"partnerId,omitempty"`
	DocumentItem *models.DocumentItem `json:"document_item"`
}

type GenerateEfacturaDocumentInput struct {
	HID        string `json:"h_id"`
	Regenerate *bool  `json:"regenerate,omitempty"`
}

type GeneratedDocument struct {
	DocumentType         string `json:"document_type"`
	Number               string `json:"number"`
	DocumentSourceNumber string `json:"document_source_number"`
}

type GetDocumentsInput struct {
	DocumentType int      `json:"document_type"`
	StartDate    string   `json:"start_date"`
	EndDate      string   `json:"end_date"`
	Status       *string  `json:"status,omitempty"`
	Partner      []string `json:"partner,omitempty"`
}

type GetGenerateAvailableItemsInput struct {
	DocumentTypeID int    `json:"document_type_id"`
	PartnerID      string `json:"partner_id"`
	Date           string `json:"date"`
	TransactionID  int    `json:"transaction_id"`
}

type GetItemsInput struct {
	CategoryList []int `json:"category_list,omitempty"`
}

type Individual struct {
	Name              string          `json:"name"`
	IndividualNumber  string          `json:"individual_number"`
	IndividualAddress *models.Address `json:"individual_address,omitempty"`
}

type ItemCategoryInput struct {
	ID         *int   `json:"id,omitempty"`
	Name       string `json:"name"`
	IsActive   bool   `json:"is_active"`
	GeneratePn bool   `json:"generate_pn"`
}

type ItemInput struct {
	ID         *string `json:"id,omitempty"`
	Code       *string `json:"code,omitempty"`
	Name       string  `json:"name"`
	IDUm       int     `json:"id_um"`
	IDVat      int     `json:"id_vat"`
	IDCategory *int    `json:"id_category,omitempty"`
	IsActive   bool    `json:"is_active"`
	IsStock    bool    `json:"is_stock"`
}

type Mutation struct {
}

type PartnerInput struct {
	ID             *string `json:"id,omitempty"`
	Code           *string `json:"code,omitempty"`
	Name           string  `json:"name"`
	Type           string  `json:"type"`
	TaxID          *string `json:"tax_id,omitempty"`
	CompanyNumber  *string `json:"company_number,omitempty"`
	PersonalNumber *string `json:"personal_number,omitempty"`
	IsActive       *bool   `json:"is_active,omitempty"`
}

type ProductionNote struct {
	Date         string    `json:"date"`
	PartnerName  string    `json:"partner_name"`
	ItemName     string    `json:"item_name"`
	ItemQuantity float64   `json:"item_quantity"`
	RawMaterial  []float64 `json:"raw_material,omitempty"`
}

type Query struct {
}

type ReportInput struct {
	StartDate string   `json:"start_date"`
	EndDate   string   `json:"end_date"`
	Partners  []string `json:"partners,omitempty"`
}

type SaveRecipeInput struct {
	ID            *int                 `json:"id,omitempty"`
	Name          string               `json:"name"`
	IsActive      bool                 `json:"is_active"`
	DocumentItems []*DocumentItemInput `json:"document_items,omitempty"`
}

type SaveUserInput struct {
	ID          string  `json:"id"`
	Email       *string `json:"email,omitempty"`
	PhoneNumber string  `json:"phone_number"`
}

type StockReportInput struct {
	Date             *string  `json:"date,omitempty"`
	InventoryList    []int    `json:"inventory_list,omitempty"`
	ItemCategoryList []int    `json:"item_category_list,omitempty"`
	ItemList         []string `json:"item_list,omitempty"`
}

type StockReportItem struct {
	ItemCode     *string `json:"item_code,omitempty"`
	ItemName     string  `json:"item_name"`
	ItemUm       *string `json:"item_um,omitempty"`
	ItemQuantity float64 `json:"item_quantity"`
}

type TransactionAvailableItemsInput struct {
	Partners      []string `json:"partners,omitempty"`
	TransactionID int      `json:"transaction_id"`
}

type UpdateUserInput struct {
	User    *UserInput    `json:"user,omitempty"`
	Company *CompanyInput `json:"company,omitempty"`
}

type UserInput struct {
	ID          string        `json:"id"`
	Email       string        `json:"email"`
	PhoneNumber *string       `json:"phone_number,omitempty"`
	Company     *CompanyInput `json:"company"`
}

type ProductionItemType string

const (
	ProductionItemTypeFinalProduct ProductionItemType = "finalProduct"
	ProductionItemTypeRawMaterial  ProductionItemType = "rawMaterial"
)

var AllProductionItemType = []ProductionItemType{
	ProductionItemTypeFinalProduct,
	ProductionItemTypeRawMaterial,
}

func (e ProductionItemType) IsValid() bool {
	switch e {
	case ProductionItemTypeFinalProduct, ProductionItemTypeRawMaterial:
		return true
	}
	return false
}

func (e ProductionItemType) String() string {
	return string(e)
}

func (e *ProductionItemType) UnmarshalGQL(v interface{}) error {
	str, ok := v.(string)
	if !ok {
		return fmt.Errorf("enums must be strings")
	}

	*e = ProductionItemType(str)
	if !e.IsValid() {
		return fmt.Errorf("%s is not a valid ProductionItemType", str)
	}
	return nil
}

func (e ProductionItemType) MarshalGQL(w io.Writer) {
	fmt.Fprint(w, strconv.Quote(e.String()))
}
