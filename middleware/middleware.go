package middleware

import (
	"log"
	"net/http"
	"strings"

	jwtmiddleware "github.com/auth0/go-jwt-middleware"
	jwt "github.com/dgrijalva/jwt-go"
	"github.com/prest/config"
)

// WhiteMiddleware open endpoints
func WhiteMiddleware(w http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	match := []string{"/auth", "/token"}
	for _, m := range match {
		if strings.Contains(r.URL.String(), m) {
			next(w, r)
			return
		}
	}
	jwtMiddleware := jwtmiddleware.New(jwtmiddleware.Options{
		ValidationKeyGetter: func(token *jwt.Token) (interface{}, error) {
			return []byte(config.PrestConf.JWTKey), nil
		},
		SigningMethod: jwt.SigningMethodHS256,
	})
	err := jwtMiddleware.CheckJWT(w, r)
	if err != nil {
		log.Println("check jwt error", err.Error())
		return
	}
	next(w, r)
}
