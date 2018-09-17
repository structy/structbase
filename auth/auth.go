package auth

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/prest/config"
	"github.com/structy/structbase/token"
)

type KeySecret struct {
	Key    string
	Secret string
	Rules  []string
}

type Auth struct {
	Data  KeySecret
	Token string
}

// Post to generate token
func Handler(w http.ResponseWriter, r *http.Request) {
	handlerKeySecret := KeySecret{}
	defer r.Body.Close()
	if err := json.NewDecoder(r.Body).Decode(&handlerKeySecret); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	tokens := []KeySecret{}
	query := "SELECT key, secret, rules FROM tokens WHERE key=$1 and secret=$2 LIMIT 1"
	cq := config.PrestConf.Adapter.Query(query, handlerKeySecret.Key, handlerKeySecret.Secret)
	err := json.Unmarshal(cq.Bytes(), &tokens)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if len(tokens) == 0 {
		http.Error(w, "Key/Secret not found", http.StatusBadRequest)
		return
	}
	tokenJson, err := json.Marshal(tokens[0])
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	tokenString, err := token.Generate(fmt.Sprintf(string(tokenJson)))
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	authPF := Auth{
		Data:  tokens[0],
		Token: tokenString,
	}
	w.WriteHeader(http.StatusOK)
	ret, _ := json.Marshal(authPF)
	w.Write(ret)
}
