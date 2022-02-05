package devAuth

import (
	"context"
	"fmt"
	"golang.org/x/oauth2"
	"log"
	"net/http"
)

func GithubAuth() *http.Client {
	ctx := context.Background()
	conf := &oauth2.Config{
		ClientID:     "3569cf3d4c2b88ddc23e",
		ClientSecret: "6d47da5ddb50575977f2f7b32381b217ae8ff785",
		Scopes:       []string{"user", "repo"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://github.com/login/oauth/authorize",
			TokenURL: "https://github.com/login/oauth/access_token",
		},
	}

	// Redirect user to consent page to ask for permission
	// for the scopes specified above.
	url := conf.AuthCodeURL("state", oauth2.AccessTypeOffline)
	fmt.Printf("Visit the URL for the auth dialog: %v", url)

	// Use the authorization code that is pushed to the redirect
	// URL. Exchange will do the handshake to retrieve the
	// initial access token. The HTTP Client returned by
	// conf.Client will refresh the token as necessary.
	var code string
	if _, err := fmt.Scan(&code); err != nil {
		log.Fatal(err)
	}
	tok, err := conf.Exchange(ctx, code)
	if err != nil {
		log.Fatal(err)
	}

	client := conf.Client(ctx, tok)
	return client

}
