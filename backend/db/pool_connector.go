package db

import (
	"backend/config"
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v4/pgxpool"
)

func NewPool(config *config.DatabaseSettings) (*pgxpool.Pool, error) {
	tries := 3
	var err error
	var pool *pgxpool.Pool
	dbConnectString, err := getConnectionString(config)
	for i := 0; i < tries; i++ {
		pool, err = pgxpool.Connect(context.Background(), dbConnectString)
		if pool != nil && err == nil {
			break
		} else if i == tries-1 && pool == nil {
			return nil, fmt.Errorf("unable to connect to database: %s %s", dbConnectString, err)
		}
		time.Sleep(time.Second * 1)
	}
	return pool, err
}
func getConnectionString(s *config.DatabaseSettings) (string, error) {

	return fmt.Sprintf("postgres://%s:%s@%s:%s/%s", s.User, s.Password, s.Host, s.Port, s.DbName), nil
}
