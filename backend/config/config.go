package config

import (
	"fmt"
	"log"
	"path/filepath"
	"runtime"

	"github.com/caarlos0/env/v6"
	"github.com/joho/godotenv"
)

type AppSettings struct {
	ServerPort  string `env:"SERVER_PORT" envDefault:"8080"`
	ServerHost  string `env:"SERVER_HOST" envDefault:""`
	GraphQLPath string `env:"GRAPHQL_PATH" envDefault:"/graphql"`
	Environment string `env:"ENVIRONMENT"`
	DebugMode   bool   `env:"DEBUG_MODE" envDefault:"false"`
}

type DatabaseSettings struct {
	DbName   string `env:"POSTGRES_DB_NAME" envDefault:"db"`
	Host     string `env:"POSTGRES_DB_HOST" envDefault:"localhost"`
	Port     string `env:"POSTGRES_DB_PORT" envDefault:"5432"`
	User     string `env:"POSTGRES_DB_USER" envDefault:"postgres"`
	Password string `env:"POSTGRES_DB_PASSWORD" envDefault:"postgres"`
}

type EfacturaSettings struct {
	ClientID     string `env:"EFACTURA_CLIENT_ID,notEmpty"`
	ClientSecret string `env:"EFACTURA_CLIENT_SECRET,notEmpty"`
	CallbackURL  string `env:"EFACTURA_CALLBACK_URL,notEmpty"`
	CallbackPath string `env:"EFACTURA_CALLBACK_PATH,notEmpty"`
}

type Config struct {
	AppSettings      AppSettings `yaml:"AppSettings"`
	DatabaseSettings DatabaseSettings
	EfacturaSettings EfacturaSettings
}

func Load() (*Config, error) {
	cfg := &Config{}

	if err := env.Parse(cfg); err != nil {
		return nil, fmt.Errorf("err loading configuration: %s", err)
	}

	//if cfg.AppConfig != "" {
	//	if err := yaml.Unmarshal([]byte(cfg.AppConfig), cfg); err != nil {
	//		return nil, fmt.Errorf("err loading configuration: %s", err)
	//	}
	//}

	return cfg, nil
}

func init() {
	// Get the current file path
	_, currentFilePath, _, _ := runtime.Caller(0)

	// Get the root directory path
	rootPath := filepath.Join(filepath.Dir(currentFilePath), "..")

	// Construct the .env file path
	envFilePath := filepath.Join(rootPath, ".env")

	// Load the .env file
	err := godotenv.Load(envFilePath)
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}
