package app

import (
	"backend/config"
	"backend/db"
	"backend/graph/generated"
	"backend/handlers"
	"backend/middleware"
	"backend/util"
	"context"
	"fmt"
	"github.com/99designs/gqlgen/graphql"
	"log"
	"net/http"
	"net/url"
	"time"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

type App struct {
	cfg      *config.Config
	router   *mux.Router
	server   *http.Server
	services *handlers.Resolver
}

func NewApp(cfg *config.Config) *App {
	return &App{
		cfg: cfg,
	}
}

func (app *App) Run() error {
	app.router = mux.NewRouter()

	var err error
	app.services, err = app.GetResolverDependencies()
	if err != nil {
		log.Fatalf("Failed to get resolver dependency: %v", err)
	}

	graphMiddleware := func(next http.Handler) http.Handler {
		handler := next
		// Add the cors function to the router
		handler = middleware.CorsMiddleware(handler)
		// Add DataLoader middleware
		handler = middleware.LoadersMiddleware(app.services.DBProvider)(handler)
		// Add the middleware function to the router
		//handler = middleware.AuthMiddleware(handler)
		return handler
	}

	// Initialize GraphQL server
	graphQlConfig := generated.Config{Resolvers: app.services}

	// Add the isAuthenticated directive logic to the GraphQL configuration
	graphQlConfig.Directives.IsAuthenticated = func(ctx context.Context, obj interface{}, next graphql.Resolver) (res interface{}, err error) {
		// Assuming you have a middleware that sets a "userId" in the context if authenticated
		if ctxUserIdVal := ctx.Value("userId"); ctxUserIdVal != nil {
			if _, ok := ctxUserIdVal.(string); ok {
				return next(ctx)
			}
		}
		return nil, fmt.Errorf("Access denied")
	}

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(graphQlConfig))
	app.router.Handle("/", graphMiddleware(
		playground.Handler("GraphQL playground", app.cfg.AppSettings.GraphQLPath)))

	app.router.Handle(app.cfg.AppSettings.GraphQLPath, graphMiddleware(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			srv.ServeHTTP(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	})))

	app.router.HandleFunc(app.cfg.EfacturaSettings.CallbackPath, func(w http.ResponseWriter, r *http.Request) {
		redirect := func(redirectURL string, err error) {
			if err != nil {
				redirectURL, _ = util.AddGetParams(redirectURL, url.Values{
					"error": {"authorization_error"},
				})
			}
			http.Redirect(w, r, redirectURL, http.StatusSeeOther)
		}
		company, err := app.services.DBProvider.GetCompany(r.Context())
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		if err = app.services.EfacturaProcessAuthorizationCallback(r); err != nil {
			app.services.Logger.Error("ProcessAuthorizationCallback failed: %v", zap.Error(err))
		}
		redirect(company.FrontendUrl.String, err)
	})

	addr := fmt.Sprintf("%s:%s", app.cfg.AppSettings.ServerHost, app.cfg.AppSettings.ServerPort)

	app.server = app.StartServer(addr)

	return nil

}

func (app *App) StartServer(addr string) *http.Server {

	srv := &http.Server{Addr: addr, Handler: app.router}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			panic(fmt.Sprintf("err server listen: %s", err))
		}
	}()
	return srv
}
func (app *App) StopServer() error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	server := &http.Server{}

	if err := server.Shutdown(ctx); err != nil {
		return err
	}

	log.Println("Server stopped")
	return nil
}
func (app *App) GetResolverDependencies() (*handlers.Resolver, error) {
	pool, err := db.NewPool(&app.cfg.DatabaseSettings)
	if err != nil {
		return nil, fmt.Errorf("initialization failed: %s", err)
	}

	var logger *zap.Logger
	if app.cfg.AppSettings.DebugMode {
		logger, err = zap.NewDevelopment()
	} else {
		logger, err = zap.NewProduction()
	}

	if err != nil {
		return nil, fmt.Errorf("failed while initializating logger: %s", err)
	}

	dbProvider := db.New(pool)

	// Create the resolver
	resolver := &handlers.Resolver{
		Logger:           logger,
		DBProvider:       dbProvider,
		DBPool:           pool,
		EfacturaSettings: app.cfg.EfacturaSettings,
	}

	return resolver, nil

}
