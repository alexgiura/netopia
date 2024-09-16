package models

type Department struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Flags int    `json:"flags"`
}
