package handlers

import (
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
	"strings"
	"time"
)

func (r *Resolver) GetCompanyInfo(ctx context.Context, taxID *string) (*models.Company, error) {
	const baseURL = "https://webservicesp.anaf.ro/PlatitorTvaRest/api/v8/ws/tva"
	date := time.Now().Format("2006-01-02")
	requestBody := fmt.Sprintf(`[{"cui": "%s", "data": "%s"}]`, *taxID, date)

	client := &http.Client{Timeout: time.Second * 5}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL, bytes.NewBufferString(requestBody))
	if err != nil {
		log.Printf("Failed to create request: %v", err)
		return nil, err
	}
	req.Header.Add("Content-Type", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		log.Printf("Failed to make HTTP request: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Failed to read response body: %v", err)
		return nil, err
	}

	var apiResp models.ApiResponse
	if err := json.Unmarshal(body, &apiResp); err != nil {
		log.Printf("Failed to unmarshal API response: %v", err)
		return nil, err
	}

	if len(apiResp.Found) > 0 {
		return MapToCompany(apiResp), nil
	}

	return nil, nil
}

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
		Id:                 row.ID.String(),
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

func (r *Resolver) _GetCompanyByTaxId(ctx context.Context, taxId *string) (*models.Company, error) {
	row, err := r.DBProvider.GetCompanyByTaxId(ctx, *taxId)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		log.Print("\"message\":Failed to execute DBProvider.GetCompanyByTaxId, "+"\"error\": ", err.Error())
		return nil, _err.Error(ctx, "InvalidCompany", "DatabaseError")
	}
	return &models.Company{
		Id:                 row.ID.String(),
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
			VatNumber:          util.IntToString(int64(dateGenerale.Cui)),
			Vat:                foundObj.InregistrareScopTva.ScpTVA,
			RegistrationNumber: &dateGenerale.NrRegCom,

			CompanyAddress: &models.Address{
				Address:    &address,
				Locality:   &adresaSediuSocial.SdenumireLocalitate,
				CountyCode: &adresaSediuSocial.ScodJudetAuto,
			},
		}
	}

	return nil
}
