package middleware

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	firebase "firebase.google.com/go"
	"github.com/rs/cors"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/gqlerror"
	"google.golang.org/api/option"
)

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Get the authorization header from the request
		authHeader := r.Header.Get("Authorization")

		if authHeader == "" {
			WriteError(w, "TokenNotFound", "Authorization header not found")
		}

		// Check if the authorization header is in the format "Bearer <token>"
		if len(authHeader) < 7 || authHeader[:7] != "Bearer " {
			WriteError(w, "invalid-jwt", "Invalid JWT-Token")
		}

		tokenString := authHeader[7:]

		// Verify the token using the Firebase Admin SDK
		opt := option.WithCredentialsFile("middleware/bildauth-firebase-adminsdk.json")
		app, err := firebase.NewApp(context.Background(), nil, opt)
		if err != nil {
			WriteError(w, "invalid-jwt", "Invalid JWT-Token")
		}

		client, err := app.Auth(context.Background())
		if err != nil {
			WriteError(w, "invalid-jwt", "Invalid JWT-Token")

		}

		// Verify the token and get the token claims
		token, err := client.VerifyIDToken(context.Background(), tokenString)
		if err != nil {
			WriteError(w, "invalid-jwt", "Invalid JWT-Token")
			return
		}

		// Extract the user ID from the token
		uid := token.UID

		// Add the user ID to the request context
		ctx := context.WithValue(r.Context(), "userId", uid)
		r = r.WithContext(ctx)

		next.ServeHTTP(w, r)
	})
}
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
