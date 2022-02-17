package google

import (
	"context"
	"fmt"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/calendar/v3"
	"google.golang.org/api/option"
	"net/http"
	"os"
	"time"
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

// CreateNewEvent creates a new Google Calendar event using the specified parameters.
func (c *Client) CreateNewEvent(title string, start time.Time, duration time.Duration) error {
	srv, err := calendar.NewService(c.ctx, option.WithHTTPClient(c.clt))
	if err != nil {
		return fmt.Errorf("failed to create google calendar service: %w", err)
	}

	_, err = srv.Events.Insert("primary", &calendar.Event{
		Summary: title,
		Start: &calendar.EventDateTime{
			DateTime: start.Format(time.RFC3339),
		},
		End: &calendar.EventDateTime{
			DateTime: start.Add(duration).Format(time.RFC3339),
		},
	}).Do()

	if err != nil {
		return fmt.Errorf("failed to create new google calendar event: %w", err)
	}

	return nil
}

// CreateNewDocument creates a new Google Docs document using the given title.
func (c *Client) CreateNewDocument(title string) {
	fmt.Println("Call from CreateNewDocument: ", title)
}

// CreateNewSheet creates a new Google Sheet document using the given title.
func (c *Client) CreateNewSheet(title string) {
	fmt.Println("Call from CreateNewSheet: ", title)
}
