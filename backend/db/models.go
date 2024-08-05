// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0

package db

import (
	"database/sql"
	"database/sql/driver"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgtype"
)

type CoreEfacturaAuthorizationStatus string

const (
	CoreEfacturaAuthorizationStatusNew          CoreEfacturaAuthorizationStatus = "new"
	CoreEfacturaAuthorizationStatusError        CoreEfacturaAuthorizationStatus = "error"
	CoreEfacturaAuthorizationStatusCodeReceived CoreEfacturaAuthorizationStatus = "code_received"
	CoreEfacturaAuthorizationStatusSuccess      CoreEfacturaAuthorizationStatus = "success"
)

func (e *CoreEfacturaAuthorizationStatus) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = CoreEfacturaAuthorizationStatus(s)
	case string:
		*e = CoreEfacturaAuthorizationStatus(s)
	default:
		return fmt.Errorf("unsupported scan type for CoreEfacturaAuthorizationStatus: %T", src)
	}
	return nil
}

type NullCoreEfacturaAuthorizationStatus struct {
	CoreEfacturaAuthorizationStatus CoreEfacturaAuthorizationStatus
	Valid                           bool // Valid is true if CoreEfacturaAuthorizationStatus is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullCoreEfacturaAuthorizationStatus) Scan(value interface{}) error {
	if value == nil {
		ns.CoreEfacturaAuthorizationStatus, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.CoreEfacturaAuthorizationStatus.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullCoreEfacturaAuthorizationStatus) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.CoreEfacturaAuthorizationStatus), nil
}

type CoreEfacturaDocumentStatus string

const (
	CoreEfacturaDocumentStatusNew        CoreEfacturaDocumentStatus = "new"
	CoreEfacturaDocumentStatusProcessing CoreEfacturaDocumentStatus = "processing"
	CoreEfacturaDocumentStatusError      CoreEfacturaDocumentStatus = "error"
	CoreEfacturaDocumentStatusSuccess    CoreEfacturaDocumentStatus = "success"
)

func (e *CoreEfacturaDocumentStatus) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = CoreEfacturaDocumentStatus(s)
	case string:
		*e = CoreEfacturaDocumentStatus(s)
	default:
		return fmt.Errorf("unsupported scan type for CoreEfacturaDocumentStatus: %T", src)
	}
	return nil
}

type NullCoreEfacturaDocumentStatus struct {
	CoreEfacturaDocumentStatus CoreEfacturaDocumentStatus
	Valid                      bool // Valid is true if CoreEfacturaDocumentStatus is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullCoreEfacturaDocumentStatus) Scan(value interface{}) error {
	if value == nil {
		ns.CoreEfacturaDocumentStatus, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.CoreEfacturaDocumentStatus.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullCoreEfacturaDocumentStatus) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.CoreEfacturaDocumentStatus), nil
}

type CoreEfacturaMessageState string

const (
	CoreEfacturaMessageStateProcessing CoreEfacturaMessageState = "processing"
	CoreEfacturaMessageStateXmlErrors  CoreEfacturaMessageState = "xml_errors"
	CoreEfacturaMessageStateOk         CoreEfacturaMessageState = "ok"
	CoreEfacturaMessageStateNok        CoreEfacturaMessageState = "nok"
)

func (e *CoreEfacturaMessageState) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = CoreEfacturaMessageState(s)
	case string:
		*e = CoreEfacturaMessageState(s)
	default:
		return fmt.Errorf("unsupported scan type for CoreEfacturaMessageState: %T", src)
	}
	return nil
}

type NullCoreEfacturaMessageState struct {
	CoreEfacturaMessageState CoreEfacturaMessageState
	Valid                    bool // Valid is true if CoreEfacturaMessageState is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullCoreEfacturaMessageState) Scan(value interface{}) error {
	if value == nil {
		ns.CoreEfacturaMessageState, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.CoreEfacturaMessageState.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullCoreEfacturaMessageState) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.CoreEfacturaMessageState), nil
}

type CoreCompany struct {
	ID                 uuid.UUID
	Name               string
	VatNumber          string
	Vat                bool
	RegistrationNumber sql.NullString
	Address            string
	Locality           sql.NullString
	CountyCode         sql.NullString
	Email              sql.NullString
	BankName           sql.NullString
	BankAccount        sql.NullString
	FrontendUrl        sql.NullString
}

type CoreDocumentConnection struct {
	ID            int32
	IDTransaction int32
	HID           uuid.UUID
	DID           uuid.UUID
	HIDSource     uuid.UUID
	DIDSource     uuid.UUID
	ItemID        uuid.UUID
	Quantity      float64
}

type CoreDocumentCurrency struct {
	ID   int32
	Name string
}

type CoreDocumentDetail struct {
	DID        uuid.UUID
	HID        uuid.UUID
	ItemID     uuid.UUID
	Quantity   float64
	Price      sql.NullFloat64
	NetValue   sql.NullFloat64
	VatValue   sql.NullFloat64
	GrosValue  sql.NullFloat64
	DIDSource  uuid.NullUUID
	ItemTypePn sql.NullString
}

type CoreDocumentHeader struct {
	HID                             uuid.UUID
	DocumentType                    int32
	Series                          sql.NullString
	Number                          string
	PartnerID                       uuid.UUID
	DocumentPartnerBillingDetailsID sql.NullInt32
	Date                            time.Time
	DueDate                         sql.NullTime
	InventoryID                     sql.NullInt32
	RepresentativeID                uuid.NullUUID
	RecipeID                        sql.NullInt32
	CurrencyID                      sql.NullInt32
	Notes                           sql.NullString
	IsDeleted                       bool
	Status                          sql.NullString
}

type CoreDocumentPartnerBillingDetail struct {
	ID                 int32
	PartnerID          uuid.UUID
	Vat                bool
	RegistrationNumber sql.NullString
	Address            string
	Locality           sql.NullString
	CountyCode         sql.NullString
	CreatedAt          time.Time
}

type CoreDocumentTransaction struct {
	ID                        int32
	Name                      string
	DocumentTypeSourceID      int32
	DocumentTypeDestinationID int32
}

type CoreDocumentType struct {
	ID       int32
	NameRo   string
	NameEn   sql.NullString
	IsInput  bool
	IsOutput bool
}

type CoreEfacturaAuthorization struct {
	AID            uuid.UUID
	CompanyID      uuid.UUID
	Status         CoreEfacturaAuthorizationStatus
	Code           sql.NullString
	Token          pgtype.JSON
	TokenExpiresAt sql.NullTime
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

type CoreEfacturaDocument struct {
	EID         uuid.UUID
	HID         uuid.UUID
	XID         int64
	UID         sql.NullInt64
	Status      CoreEfacturaDocumentStatus
	UploadIndex sql.NullInt64
	DownloadID  sql.NullInt64
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type CoreEfacturaDocumentUpload struct {
	ID          int64
	EID         uuid.UUID
	XID         int64
	Status      CoreEfacturaDocumentStatus
	UploadIndex sql.NullInt64
	DownloadID  sql.NullInt64
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type CoreEfacturaMessage struct {
	ID           int64
	UID          int64
	State        CoreEfacturaMessageState
	DownloadID   sql.NullInt64
	ErrorMessage sql.NullString
	CreatedAt    time.Time
}

type CoreEfacturaXmlDocument struct {
	ID            int64
	HID           uuid.UUID
	InvoiceXml    string
	InvoiceMd5Sum string
	CreatedAt     time.Time
}

type CoreInventory struct {
	ID       int32
	Name     string
	IsActive bool
}

type CoreItem struct {
	ID         uuid.UUID
	Code       sql.NullString
	Name       string
	IsActive   bool
	IDUm       int32
	IsStock    bool
	IDVat      int32
	IDCategory sql.NullInt32
}

type CoreItemCategory struct {
	ID         int32
	Name       string
	IsActive   bool
	GeneratePn bool
}

type CoreItemUm struct {
	ID       int32
	Name     string
	Code     string
	IsActive bool
}

type CoreItemVat struct {
	ID                  int32
	Name                string
	Percent             float64
	ExemptionReason     sql.NullString
	ExemptionReasonCode sql.NullString
	IsActive            bool
}

type CorePartner struct {
	ID                 uuid.UUID
	Code               sql.NullString
	Name               string
	IsActive           bool
	Type               string
	VatNumber          sql.NullString
	Vat                bool
	RegistrationNumber sql.NullString
	Address            sql.NullString
	Locality           sql.NullString
	CountyCode         sql.NullString
	CreatedAt          time.Time
}

type CorePerson struct {
	ID       uuid.UUID
	Name     string
	IsActive bool
}

type CoreRecipe struct {
	ID       int32
	Name     string
	IsActive bool
}

type CoreRecipeItem struct {
	DID                uuid.UUID
	RecipeID           int32
	ItemID             uuid.UUID
	Quantity           float64
	ProductionItemType string
}

type CoreUser struct {
	ID          string
	PhoneNumber sql.NullString
	Name        sql.NullString
	Email       string
}
