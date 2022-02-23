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
	"idefix/services/github"
	"log"
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

// CalendarNearestEvent check if event's calendar begin before 10 minutes
func (c *Client) CalendarNearestEvent(taskID string, prm *structpb.Struct) error {
	var gc GCalendar

	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure github client: %w", err)
	}

	srv, err := calendar.NewService(context.Background(), option.WithHTTPClient(c.Requester))
	if err != nil {
		log.Fatalf("Unable to retrieve Calendar client: %v", err)
	}

	if err = gc.Parse(srv); err != nil || !errors.Is(err, ErrNoUpcomingEvent) {
		return fmt.Errorf("failed to parse gcalendar data: %w", err)
	}

	old, err := gc.GetRedisState(c.Operator.RC, taskID)
	if err != nil {
		if errors.Is(err, github.ErrNoIssues) {
			return nil
		}

		return fmt.Errorf("failed to update redis state: %w", err)
	}

	err = gc.LookForChange(c.Operator, taskID, old)
	if err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}
