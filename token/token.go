package token

import (
	"time"

	jwt "github.com/dgrijalva/jwt-go"
	"github.com/prest/config"
)

// Generate api access token
func Generate(Issuer string) (signedToken string, err error) {
	// Create the Claims
	claims := &jwt.StandardClaims{
		ExpiresAt: time.Now().Add(time.Hour * 1).Unix(),
		Issuer:    Issuer,
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signedToken, err = token.SignedString([]byte(config.PrestConf.JWTKey))
	return
}
