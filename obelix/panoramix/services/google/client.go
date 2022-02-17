package google

import (
	"context"
	"fmt"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"net/http"
	"os"
)

var (
	ClientID     = ""
	ClientSecret = ""
	RedirectURL  = ""
)

// TODO : Must be removed when the credentials API is up.
func init() {
	ClientID = os.Getenv("GOOGLE_CLIENT_ID")
	ClientSecret = os.Getenv("GOOGLE_CLIENT_SECRET")
	RedirectURL = os.Getenv("GOOGLE_REDIRECT_URL")
}

// Client represents a minimal Google client able to make OAuth2.0 authenticated requests.
type Client struct {
	ctx context.Context
	clt *http.Client
}

// New creates a new Google client based on the given scopes/
func New(ctx context.Context, scopes []string) (*Client, error) {
	conf := &oauth2.Config{
		ClientID:     ClientID,
		ClientSecret: ClientSecret,
		Endpoint:     google.Endpoint,
		RedirectURL:  RedirectURL,
		Scopes:       scopes,
	}

	token, err := GetAccessToken(ctx, conf)
	if err != nil {
		return nil, fmt.Errorf("failed to get google access token: %w", err)
	}

	return &Client{
		ctx: ctx,
		clt: conf.Client(ctx, token),
	}, nil
}

// CreateNewDocument creates a new Google Docs document using the given title.
func (c *Client) CreateNewDocument(title string) {
	fmt.Println("Call from CreateNewDocument: ", title)
}

// CreateNewSheet creates a new Google Sheet document using the given title.
func (c *Client) CreateNewSheet(title string) {
	fmt.Println("Call from CreateNewSheet: ", title)
}
