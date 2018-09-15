package auth

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/mining/mds/token"
	"github.com/prest/config"
)

type keySecret struct {
	Key    string
	Secret string
}

type Auth struct {
	Data  keySecret
	Token string
}

// Post to generate token
func Handler(w http.ResponseWriter, r *http.Request) {
	handlerKeySecret := keySecret{}
	defer r.Body.Close()
	if err := json.NewDecoder(r.Body).Decode(&handlerKeySecret); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	tokens := []keySecret{}
	query := "SELECT key, secret FROM tokens WHERE key=$1 and secret=$2 LIMIT 1"
	fmt.Println("here 1")
	cq := config.PrestConf.Adapter.Query(query, handlerKeySecret.Key, handlerKeySecret.Secret)
	fmt.Println("here 2")
	err := json.Unmarshal(cq.Bytes(), &tokens)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if len(tokens) == 0 {
		http.Error(w, "Key/Secret not found", http.StatusBadRequest)
		return
	}
	tokenString, err := token.Generate(fmt.Sprintf("%s-%s", tokens[0].Key, tokens[0].Secret))
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
