package devauth

import (
	"context"
	"errors"
	"fmt"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"log"
	"net/http"
	"os"
)

var (
	GoogleClientID     = ""
	GoogleClientSecret = ""
	GoogleRedirectURL  = ""
)

func init() {
	GoogleClientID = os.Getenv("GOOGLE_CLIENT_ID")
	GoogleClientSecret = os.Getenv("GOOGLE_CLIENT_SECRET")
	GoogleRedirectURL = os.Getenv("GOOGLE_REDIRECT_URL")

	if GoogleClientID == "" || GoogleClientSecret == "" || GoogleRedirectURL == "" {
		log.Fatal(errors.New("google credentials are not set"))
	}
}

type Client struct {
	ctx context.Context
	Clt *http.Client
}

// New creates a new Google client
func New(ctx context.Context, scopes []string) (*Client, error) {
	conf := &oauth2.Config{
		ClientID:     GoogleClientID,
		ClientSecret: GoogleClientSecret,
		Endpoint:     google.Endpoint,
		RedirectURL:  GoogleRedirectURL,
		Scopes:       scopes,
	}

	token, err := GetAccessToken(ctx, conf)
	if err != nil {
		return nil, fmt.Errorf("failed to get google access token: %w", err)
	}

	return &Client{
		ctx: ctx,
		Clt: conf.Client(ctx, token),
	}, nil
}
