package models

type ApiResponse struct {
	Cod      int           `json:"cod"`
	Message  string        `json:"message"`
	Found    []FoundObj    `json:"found"`
	NotFound []interface{} `json:"notFound"`
}

type FoundObj struct {
	DateGenerale          DateGeneraleObj          `json:"date_generale"`
	InregistrareScopTva   InregistrareScopTvaObj   `json:"inregistrare_scop_Tva"`
	InregistrareRTVAI     InregistrareRTVAIObj     `json:"inregistrare_RTVAI"`
	StareInactiv          StareInactivObj          `json:"stare_inactiv"`
	InregistrareSplitTVA  InregistrareSplitTVAObj  `json:"inregistrare_SplitTVA"`
	AdresaSediuSocial     AdresaSediuSocialObj     `json:"adresa_sediu_social"`
	AdresaDomiciliuFiscal AdresaDomiciliuFiscalObj `json:"adresa_domiciliu_fiscal"`
}

type DateGeneraleObj struct {
	Cui                  int    `json:"cui"`
	Data                 string `json:"data"`
	Denumire             string `json:"denumire"`
	Adresa               string `json:"adresa"`
	NrRegCom             string `json:"nrRegCom"`
	Telefon              string `json:"telefon"`
	Fax                  string `json:"fax"`
	CodPostal            string `json:"codPostal"`
	Act                  string `json:"act"`
	StareInregistrare    string `json:"stare_inregistrare"`
	DataInregistrare     string `json:"data_inregistrare"`
	CodCAEN              string `json:"cod_CAEN"`
	Iban                 string `json:"iban"`
	StatusROEFactura     bool   `json:"statusRO_e_Factura"`
	OrganFiscalCompetent string `json:"organFiscalCompetent"`
	FormaDeProprietate   string `json:"forma_de_proprietate"`
	FormaOrganizare      string `json:"forma_organizare"`
	FormaJuridica        string `json:"forma_juridica"`
}

type InregistrareScopTvaObj struct {
	ScpTVA      bool             `json:"scpTVA"`
	PerioadeTVA []PerioadeTVAObj `json:"perioade_TVA"`
}

type PerioadeTVAObj struct {
	DataInceputScpTVA string `json:"data_inceput_ScpTVA"`
	DataSfarsitScpTVA string `json:"data_sfarsit_ScpTVA"`
	DataAnulImpScpTVA string `json:"data_anul_imp_ScpTVA"`
	MesajScpTVA       string `json:"mesaj_ScpTVA"`
}

type InregistrareRTVAIObj struct {
	DataInceputTvaInc     string `json:"dataInceputTvaInc"`
	DataSfarsitTvaInc     string `json:"dataSfarsitTvaInc"`
	DataActualizareTvaInc string `json:"dataActualizareTvaInc"`
	DataPublicareTvaInc   string `json:"dataPublicareTvaInc"`
	TipActTvaInc          string `json:"tipActTvaInc"`
	StatusTvaIncasare     bool   `json:"statusTvaIncasare"`
}

type StareInactivObj struct {
	DataInactivare string `json:"dataInactivare"`
	DataReactivare string `json:"dataReactivare"`
	DataPublicare  string `json:"dataPublicare"`
	DataRadiere    string `json:"dataRadiere"`
	StatusInactivi bool   `json:"statusInactivi"`
}

type InregistrareSplitTVAObj struct {
	DataInceputSplitTVA string `json:"dataInceputSplitTVA"`
	DataAnulareSplitTVA string `json:"dataAnulareSplitTVA"`
	StatusSplitTVA      bool   `json:"statusSplitTVA"`
}

type AdresaSediuSocialObj struct {
	SdenumireStrada     string `json:"sdenumire_Strada"`
	SnumarStrada        string `json:"snumar_Strada"`
	SdenumireLocalitate string `json:"sdenumire_Localitate"`
	ScodLocalitate      string `json:"scod_Localitate"`
	SdenumireJudet      string `json:"sdenumire_Judet"`
	ScodJudet           string `json:"scod_Judet"`
	ScodJudetAuto       string `json:"scod_JudetAuto"`
	Stara               string `json:"stara"`
	SdetaliiAdresa      string `json:"sdetalii_Adresa"`
	ScodPostal          string `json:"scod_Postal"`
}

type AdresaDomiciliuFiscalObj struct {
	DdenumireStrada     string `json:"ddenumire_Strada"`
	DnumarStrada        string `json:"dnumar_Strada"`
	DdenumireLocalitate string `json:"ddenumire_Localitate"`
	DcodLocalitate      string `json:"dcod_Localitate"`
	DdenumireJudet      string `json:"ddenumire_Judet"`
	DcodJudet           string `json:"dcod_Judet"`
	DcodJudetAuto       string `json:"dcod_JudetAuto"`
	Dtara               string `json:"dtara"`
	DdetaliiAdresa      string `json:"ddetalii_Adresa"`
	DcodPostal          string `json:"dcod_Postal"`
}
