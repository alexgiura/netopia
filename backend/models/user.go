package models

type User struct {
	Id          string  `json:"id"`
	Email       string  `json:"email"`
	PhoneNumber *string `json:"phone_number"`
}
