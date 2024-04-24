package handlers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
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

func getPartnerInfo(taxId string, date time.Time) (*Partner, error) {
	url := "https://webservicesp.anaf.ro/PlatitorTvaRest/api/v8/ws/tva"

	requestBody := []map[string]string{
		{
			"cui":  taxId,
			"data": date.Format("2006-01-02"),
		},
	}
	requestBodyBytes, err := json.Marshal(requestBody)
	if err != nil {
		return nil, err
	}

	// Make the request
	resp, err := http.Post(url, "application/json", bytes.NewBuffer(requestBodyBytes))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var apiResp ApiResponse
	err = json.Unmarshal(body, &apiResp)
	if err != nil {
		return nil, err
	}

	if len(apiResp.Found) > 0 {
		return &apiResp.Found[0].GeneralInfo, nil
	}

	return nil, fmt.Errorf("no data found for the provided tax ID and date")
}
