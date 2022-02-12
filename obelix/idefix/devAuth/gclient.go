package devAuth

import (
	"context"
	"fmt"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"net/http"
	"os"
)

var (
	CLIENT_ID     = ""
	CLIENT_SECRET = ""
	REDIRECT_URL  = ""
)

func init() {
	CLIENT_ID = os.Getenv("GOOGLE_CLIENT_ID")
	CLIENT_SECRET = os.Getenv("GOOGLE_CLIENT_SECRET")
	REDIRECT_URL = os.Getenv("GOOGLE_REDIRECT_URL")
}

type Client struct {
	ctx context.Context
	Clt *http.Client
}

// New creates a new Google client
func New(ctx context.Context, scopes []string) (*Client, error) {
	conf := &oauth2.Config{
		ClientID:     CLIENT_ID,
		ClientSecret: CLIENT_SECRET,
		Endpoint:     google.Endpoint,
		RedirectURL:  REDIRECT_URL,
		Scopes:       scopes,
	}

	tok, err := GetAccessToken(ctx, conf)
	if err != nil {
		return nil, fmt.Errorf("failed to get google access token: %w", err)
	}

	return &Client{
		ctx: ctx,
		Clt: conf.Client(ctx, tok),
	}, nil
}
