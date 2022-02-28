package google

import (
	"context"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/calendar/v3"
	"google.golang.org/api/option"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/operator"
	"idefix/redis"
	"log"
	"net/http"
	"os"
)

var (
	ClientID     = ""
	ClientSecret = ""
	RedirectURL  = ""
)

func init() {
	ClientID = os.Getenv("GOOGLE_CLIENT_ID")
	ClientSecret = os.Getenv("GOOGLE_CLIENT_SECRET")
	RedirectURL = os.Getenv("GOOGLE_REDIRECT_URL")

	if ClientID == "" || ClientSecret == "" || RedirectURL == "" {
		log.Fatal(errors.New("google credentials are not set"))
	}
}

// Client represents a minimal Google client able to make OAuth2.0 authenticated requests.
type Client struct {
	ctx       context.Context
	Requester *http.Client
	Scope     []string
	Operator  *operator.IdefixOperator
}

func New(ctx context.Context, scopes []string, op *operator.IdefixOperator) *Client {
	return &Client{
		ctx:       ctx,
		Requester: nil,
		Scope:     scopes,
		Operator:  op,
	}
}

// configure get credentials to connect to Google API
func (c *Client) configure(owner string) error {
	conf := &oauth2.Config{
		ClientID:     ClientID,
		ClientSecret: ClientSecret,
		Endpoint:     google.Endpoint,
		RedirectURL:  RedirectURL,
		Scopes:       c.Scope,
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
	c.Requester = conf.Client(c.ctx, token)

	return nil
}

// NewIncomingEvent check if event's calendar begin before 10 minutes
func (c *Client) NewIncomingEvent(taskID string, prm *structpb.Struct, owner string) error {
	var gc GCalendar

	// Creates a Google client with the user's credentials loaded.
	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure github client: %w", err)
	}

	// Creates a Google calendar service using the Google client previously created.
	srv, err := calendar.NewService(context.Background(), option.WithHTTPClient(c.Requester))
	if err != nil {
		return fmt.Errorf("unable to retrieve Calendar client: %w", err)
	}

	// Extract the nearest event's date.
	if err = gc.Parse(srv); err != nil {
		// If there are no upcoming events in the calendar, the action will not trigger.
		if errors.Is(err, ErrNoUpcomingEvent) || errors.Is(err, redis.ErrFirstRedisLookup) {
			return nil
		}

		return fmt.Errorf("failed to parse gcalendar data: %w", err)
	}

	// Retrieves the last state from the Redis DB.
	old, err := gc.GetRedisState(c.Operator.RC, taskID)
	if err != nil {
		return fmt.Errorf("failed to update redis state: %w", err)
	}

	// Verifies if the event is in the range of < 10 minutes.
	if err = gc.LookForChange(c.Operator, taskID, old, owner); err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}
