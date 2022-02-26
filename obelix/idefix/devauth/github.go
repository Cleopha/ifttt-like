package devauth

import (
	"context"
	"errors"
	"fmt"
	"golang.org/x/oauth2"
	"log"
	"net/http"
	"os"
)

var (
	GithubClientID     = ""
	GithubClientSecret = ""
)

func init() {
	GithubClientID = os.Getenv("GITHUB_CLIENT_ID")
	GithubClientSecret = os.Getenv("GITHUB_CLIENT_SECRET")

	if GithubClientID == "" || GithubClientSecret == "" {
		log.Fatal(errors.New("github credentials are not set"))
	}
}

func GithubAuth() *http.Client {
	ctx := context.Background()
	conf := &oauth2.Config{
		ClientID:     GithubClientID,
		ClientSecret: GithubClientSecret,
		Scopes:       []string{"user", "repo"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://github.com/login/oauth/authorize",
			TokenURL: "https://github.com/login/oauth/access_token",
		},
	}

	// Redirect user to consent page to ask for permission
	// for the scopes specified above.
	url := conf.AuthCodeURL("state", oauth2.AccessTypeOffline)
	fmt.Printf("Visit the URL for the auth dialog: %v\n", url)

	// Use the authorization code that is pushed to the redirect
	// URL. Exchange will do the handshake to retrieve the
	// initial access token. The HTTP Client returned by
	// conf.Client will refresh the token as necessary.
	var code string
	if _, err := fmt.Scan(&code); err != nil {
		log.Fatal(err)
	}

	token, err := conf.Exchange(ctx, code)
	if err != nil {
		log.Fatal(err)
	}

	client := conf.Client(ctx, token)

	return client
}
