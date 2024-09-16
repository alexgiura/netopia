package middleware

import (
	"backend/db"
	loaders "backend/loaders"
	"context"
	"encoding/json"

	"github.com/rs/cors"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/gqlerror"

	"log"
	"net/http"
)

func CorsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Create a new CORS handler
		c := cors.New(cors.Options{
			AllowedOrigins:   []string{"*"},                             // Allow all origins
			AllowedMethods:   []string{http.MethodPost, http.MethodGet}, // Allow POST and GET methods
			AllowedHeaders:   []string{"*"},                             // Allow all headers
			AllowCredentials: false,                                     // Do not allow credentials
		})

		// Handler function to handle CORS and pass control to the next handler
		handler := c.Handler(next)

		// Serve the HTTP request
		handler.ServeHTTP(w, r)
	})
}
func LoadersMiddleware(dbProvider *db.Queries) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			loaders := loaders.NewLoaders(dbProvider)
			ctx := context.WithValue(r.Context(), "loaders", loaders)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func WriteError(w http.ResponseWriter, code string, message string) {
	gqlErr := &gqlerror.Error{
		Message: message,
		Path:    ast.Path{ast.PathName("$")},
		Extensions: map[string]interface{}{
			"code": code,
		},
	}

	errors := []*gqlerror.Error{gqlErr}
	response := struct {
		Errors []*gqlerror.Error `json:"errors"`
	}{Errors: errors}

	w.WriteHeader(http.StatusUnauthorized)
	json.NewEncoder(w).Encode(response)
}

func GetUserUUIDFromContext(ctx context.Context) (*string, bool) {
	userId, ok := ctx.Value("userId").(string)
	if !ok || userId == "" {
		// User ID not present
		log.Println("Invalid UserId in Context")
		return nil, false
	}

	return &userId, true
}
