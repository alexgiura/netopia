package main

import (
	"backend/app"
	"backend/config"
	"log"
	"os"
	"os/signal"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("failed loading env variables: %s\n", err.Error())
	}

	// Initialize the application
	app := app.NewApp(cfg)

	err = app.Run()
	if err != nil {
		log.Println("Error:", err)
	}

	// Wait for a signal to stop the server
	stopChan := make(chan os.Signal, 1)
	signal.Notify(stopChan, os.Interrupt)
	<-stopChan

	// Stop the server gracefully
	if err := app.StopServer(); err != nil {
		log.Fatalf("Failed to stop server: %v", err)
	}
}
