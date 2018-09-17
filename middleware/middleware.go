package middleware

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"

	jwtmiddleware "github.com/auth0/go-jwt-middleware"
	jwt "github.com/dgrijalva/jwt-go"
	"github.com/prest/config"
	"github.com/structy/structbase/auth"
)

var URIWhiteList = []string{"/auth", "/token"}

// WhiteMiddleware open endpoints
func WhiteMiddleware(w http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	for _, m := range URIWhiteList {
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

// RuleMiddleware validate access
func RuleMiddleware(w http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	for _, m := range URIWhiteList {
		if strings.Contains(r.URL.String(), m) {
			next(w, r)
			return
		}
	}
	u := r.Context().Value("user")
	user := u.(*jwt.Token)
	iss := user.Claims.(jwt.MapClaims)["iss"].(string)
	keySecret := auth.KeySecret{}
	if err := json.Unmarshal([]byte(iss), &keySecret); err != nil {
		log.Println("check jwt error", err.Error())
		return
	}
	for _, method := range keySecret.Rules {
		if strings.ToUpper(method) == r.Method {
			next(w, r)
			return
		}
	}
	log.Println(user, "Access Denied!")
	return
}
