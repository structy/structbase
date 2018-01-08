package main

import (
	"github.com/prest/adapters/postgres"
	"github.com/prest/cmd"
	"github.com/prest/config"
	"github.com/prest/middlewares"
)

func main() {
	config.Load()

	// Load Postgres Adapter
	postgres.Load()

	// Get pREST app
	middlewares.GetApp()

	// Call pREST cmd
	cmd.Execute()
}
