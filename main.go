package main

import (
	"github.com/mining/mds/auth"
	"github.com/mining/mds/middleware"
	"github.com/prest/adapters/postgres"
	"github.com/prest/cmd"
	"github.com/prest/config"
	"github.com/prest/config/router"
	"github.com/prest/middlewares"
	"github.com/urfave/negroni"
)

func main() {
	config.Load()

	// Load Postgres Adapter
	postgres.Load()

	// pREST middlewares
	middlewares.MiddlewareStack = []negroni.Handler{
		negroni.Handler(negroni.NewRecovery()),
		negroni.Handler(negroni.NewLogger()),
		negroni.Handler(middlewares.HandlerSet()),
		negroni.Handler(negroni.HandlerFunc(middleware.WhiteMiddleware)),
		negroni.Handler(negroni.HandlerFunc(middleware.RuleMiddleware)),
	}

	// pREST routes
	r := router.Get()
	r.HandleFunc("/auth", auth.Handler).Methods("POST")

	// Call pREST cmd
	cmd.Execute()
}
