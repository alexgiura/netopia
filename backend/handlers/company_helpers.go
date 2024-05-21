package handlers

import (
<<<<<<< HEAD
	"backend/models"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strconv"
=======
	_err "backend/errors"
	"backend/models"
	"backend/util"
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/jackc/pgx/v4"
	"io"
	"log"
	"net/http"
>>>>>>> origin/dev
	"strings"
	"time"
)

func (r *Resolver) _GetCompanyInfo(ctx context.Context, taxID *string) (*models.Company, error) {
	// Define the API endpoint URL
	url := "https://webservicesp.anaf.ro/PlatitorTvaRest/api/v8/ws/tva"
	date := time.Now().Format("2006-01-02")

	// Prepare request body
	requestBody := `[
    {
        "cui": "` + *taxID + `",
        "data": "` + date + `"
    }    
]`
	fmt.Println(requestBody)

	// Convert the request body to a byte slice
	requestBodyBytes := []byte(requestBody)

	// Make the HTTP request
	resp, err := http.Post(url, "application/json", bytes.NewReader(requestBodyBytes))
	if err != nil {
		log.Printf("Failed to make HTTP request: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	// Read response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Failed to read response body: %v", err)
		return nil, err
	}

	// Parse API response
	var apiResp models.ApiResponse
	err = json.Unmarshal(body, &apiResp)
	if err != nil {
		log.Printf("Failed to unmarshal API response: %v", err)
		return nil, err
	}

	// Check if data is found
	if len(apiResp.Found) > 0 {

		return MapToCompany(apiResp), nil

	}

	return nil, nil
}

<<<<<<< HEAD
=======
func (r *Resolver) _GetMyCompany(ctx context.Context) (*models.Company, error) {
	row, err := r.DBProvider.GetCompany(ctx)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetCompany, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "InvalidCompany", "DatabaseError")
	}
	return &models.Company{

		Name:               row.Name,
		VatNumber:          &row.VatNumber,
		Vat:                row.Vat,
		RegistrationNumber: util.StringOrNil(row.RegistrationNumber),
		CompanyAddress: &models.Address{
			Address:    &row.Address,
			Locality:   util.StringOrNil(row.Locality),
			CountyCode: util.StringOrNil(row.CountyCode),
		},
	}, nil
}

>>>>>>> origin/dev
func MapToCompany(apiResp models.ApiResponse) *models.Company {
	if len(apiResp.Found) > 0 {
		foundObj := apiResp.Found[0]
		dateGenerale := foundObj.DateGenerale
		adresaSediuSocial := foundObj.AdresaSediuSocial

		// Split the address components
		addressParts := []string{adresaSediuSocial.SdenumireStrada, adresaSediuSocial.SnumarStrada}
		address := strings.Join(addressParts, " ")

		return &models.Company{
			Name:               dateGenerale.Denumire,
<<<<<<< HEAD
			VatNumber:          strconv.Itoa(dateGenerale.Cui),
			Vat:                foundObj.InregistrareScopTva.ScpTVA,
			RegistrationNumber: dateGenerale.NrRegCom,

			CompanyAddress: &models.Address{
				Address:    address,
				Locality:   adresaSediuSocial.SdenumireLocalitate,
				CountyCode: adresaSediuSocial.ScodJudetAuto,
=======
			VatNumber:          util.IntToString(int64(dateGenerale.Cui)),
			Vat:                foundObj.InregistrareScopTva.ScpTVA,
			RegistrationNumber: &dateGenerale.NrRegCom,

			CompanyAddress: &models.Address{
				Address:    &address,
				Locality:   &adresaSediuSocial.SdenumireLocalitate,
				CountyCode: &adresaSediuSocial.ScodJudetAuto,
>>>>>>> origin/dev
			},
		}
	}

	return nil
}
