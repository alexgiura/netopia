package handlers

import (
	"backend/graph/model"
	"backend/models"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strconv"
	"time"
)

func (r *Resolver) _GetCompanyInfo(ctx context.Context, taxID *string) (*model.Company, error) {
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

func MapToCompany(apiResp models.ApiResponse) *model.Company {
	if len(apiResp.Found) > 0 {
		foundObj := apiResp.Found[0]
		dateGenerale := foundObj.DateGenerale

		return &model.Company{
			Name:               dateGenerale.Denumire,
			VatNumber:          strconv.Itoa(dateGenerale.Cui),
			RegistrationNumber: &dateGenerale.NrRegCom,
		}
	}

	return nil
}
