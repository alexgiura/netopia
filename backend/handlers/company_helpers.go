package handlers

import (
	"backend/graph/model"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"
)

//	type Partner struct {
//		Name          string `json:"denumire"`
//		TaxID         string `json:"cui"`
//		CompanyNumber string `json:"nrRegCom"`
//		Address       string `json:"adresa"` // Assuming you also want the address
//	}
//type ApiResponse struct {
//	Found []struct {
//		GeneralInfo model.Company `json:"date_generale"`
//	} `json:"found"`
//}

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
	fmt.Println("Response Body:", string(body))

	// Parse API response
	var apiResp ApiResponse
	err = json.Unmarshal(body, &apiResp)
	if err != nil {
		log.Printf("Failed to unmarshal API response: %v", err)
		return nil, err
	}

	// Check if data is found
	if len(apiResp.Found) > 0 {
		return &apiResp.Found[0].GeneralInfo, nil
	}

	return nil, nil
}
