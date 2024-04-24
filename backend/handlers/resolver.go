package handlers

import (
	"backend/config"
	"backend/db"

	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	Logger           *zap.Logger
	DBProvider       *db.Queries
	DBPool           *pgxpool.Pool
	EfacturaSettings config.EfacturaSettings
}
