package google

import (
	"context"
	"errors"
	"fmt"
	"google.golang.org/api/calendar/v3"
	"google.golang.org/api/option"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/devauth"
	"idefix/operator"
	"net/http"
)

// Client represents a minimal Google client able to make OAuth2.0 authenticated requests.
type Client struct {
	Requester *http.Client
	Scope     []string
	Operator  *operator.IdefixOperator
}

// configure get credentials to connect to Google API
func (c *Client) configure() error {
	//TODO Credentials API
	client, err := devauth.New(context.Background(), c.Scope)

	if err != nil {
		return fmt.Errorf("failed to configure google client")
	}

	c.Requester = client.Clt

	return nil
}

// NewIncomingEvent check if event's calendar begin before 10 minutes
func (c *Client) NewIncomingEvent(taskID string, prm *structpb.Struct) error {
	var gc GCalendar

	// Creates a Google client with the user's credentials loaded.
	if err := c.configure(); err != nil {
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
		if errors.Is(err, ErrNoUpcomingEvent) {
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
	if err = gc.LookForChange(c.Operator, taskID, old); err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}
