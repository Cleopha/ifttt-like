package google

import (
	"context"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"go.uber.org/zap"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/calendar/v3"
	"google.golang.org/api/docs/v1"
	"google.golang.org/api/option"
	"google.golang.org/api/sheets/v4"
	"google.golang.org/protobuf/types/known/structpb"
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
	ctx    context.Context
	clt    *http.Client
	scopes []string
}

// New creates a new Google client based on the given scopes/
func New(ctx context.Context, scopes []string) *Client {
	return &Client{
		ctx:    ctx,
		scopes: scopes,
	}
}

// configure creates the Google OAuth2 client using the access token of a specific user.
func (c *Client) configure(owner string) error {
	conf := &oauth2.Config{
		ClientID:     ClientID,
		ClientSecret: ClientSecret,
		Endpoint:     google.Endpoint,
		RedirectURL:  RedirectURL,
		Scopes:       c.scopes,
	}

	token := &oauth2.Token{}
	credentialClient, err := credentials.NewClient(os.Getenv("CREDENTIAL_API_PORT"))

	if err != nil {
		return fmt.Errorf("failed to create credential gRPC client: %w", err)
	}

	credential, err := credentialClient.GetCredential(c.ctx, &protos.GetCredentialRequest{
		Owner:   owner,
		Service: protos.Service_GOOGLE,
	})
	if err != nil {
		return fmt.Errorf("failed to query google credential: %w", err)
	}

	token.AccessToken = credential.GetToken()
	c.clt = conf.Client(c.ctx, token)

	return nil
}

// CreateNewEvent creates a new Google Calendar event using the specified parameters.
func (c *Client) CreateNewEvent(p *structpb.Struct, owner string) error {
	type paramsEvent struct {
		title    string
		start    time.Time
		duration time.Duration
	}

	var err error

	params := paramsEvent{
		title: p.Fields["title"].GetStringValue(),
	}

	params.start, err = time.Parse(time.RFC3339, p.Fields["start"].GetStringValue())
	if err != nil {
		return fmt.Errorf("failed to parse event start date: %w", err)
	}

	params.duration, err = time.ParseDuration(p.Fields["duration"].GetStringValue())
	if err != nil {
		return fmt.Errorf("failed to parse event duration: %w", err)
	}

	if err = c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure google oauth2: %w", err)
	}

	srv, err := calendar.NewService(c.ctx, option.WithHTTPClient(c.clt))
	if err != nil {
		return fmt.Errorf("failed to create google calendar service: %w", err)
	}

	_, err = srv.Events.Insert("primary", &calendar.Event{
		Summary: params.title,
		Start: &calendar.EventDateTime{
			DateTime: params.start.Format(time.RFC3339),
		},
		End: &calendar.EventDateTime{
			DateTime: params.start.Add(params.duration).Format(time.RFC3339),
		},
	}).Do()

	if err != nil {
		return fmt.Errorf("failed to create new google calendar event: %w", err)
	}

	zap.S().Info("New google event successfully created")

	return nil
}

// CreateNewDocument creates a new Google Docs document using the given title.
func (c *Client) CreateNewDocument(p *structpb.Struct, owner string) error {
	type paramsDocument struct {
		title string
	}

	params := paramsDocument{
		title: p.Fields["title"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure google oauth2: %w", err)
	}

	srv, err := docs.NewService(c.ctx, option.WithHTTPClient(c.clt))
	if err != nil {
		return fmt.Errorf("failed to create google docs service: %w", err)
	}

	_, err = srv.Documents.Create(&docs.Document{Title: params.title}).Do()
	if err != nil {
		return fmt.Errorf("failed to create new google document: %w", err)
	}

	zap.S().Info("New google document successfully created")

	return nil
}

// CreateNewSheet creates a new Google Sheet document using the given title.
func (c *Client) CreateNewSheet(p *structpb.Struct, owner string) error {
	type paramsSheet struct {
		title string
	}

	params := paramsSheet{
		title: p.Fields["title"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure google oauth2: %w", err)
	}

	srv, err := sheets.NewService(c.ctx, option.WithHTTPClient(c.clt))
	if err != nil {
		return fmt.Errorf("failed to create google sheet service: %w", err)
	}

	_, err = srv.Spreadsheets.Create(&sheets.Spreadsheet{
		Properties: &sheets.SpreadsheetProperties{
			Title: params.title,
		},
	}).Do()
	if err != nil {
		return fmt.Errorf("failed to create new google sheet: %w", err)
	}

	zap.S().Info("New google sheet successfully created")

	return nil
}
