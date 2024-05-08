package handlers

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

type Partner struct {
	Name          string `json:"denumire"`
	TaxID         string `json:"cui"`
	CompanyNumber string `json:"nrRegCom"`
	Address       string `json:"adresa"` // Assuming you also want the address
}

type ApiResponse struct {
	Found []struct {
		GeneralInfo Partner `json:"date_generale"`
	} `json:"found"`
}

func getPartnerInfo(taxID string) (*Partner, error) {
	// Define the API endpoint URL
	url := "https://webservicesp.anaf.ro/PlatitorTvaRest/api/v8/ws/tva"
	date := time.Now().Format("2006-01-02")

	// Prepare request body
	requestBody := map[string]string{
		"cui":  taxID,
		"data": date,
	}
	requestBodyBytes, err := json.Marshal(requestBody)
	if err != nil {
		log.Printf("Failed to marshal request body: %v", err)
		return nil, err
	}

	// Make the HTTP request
	resp, err := http.Post(url, "application/json", bytes.NewReader(requestBodyBytes))
	if err != nil {
		log.Printf("Failed to make HTTP request: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	// Read response body
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Failed to read response body: %v", err)
		return nil, err
	}

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
