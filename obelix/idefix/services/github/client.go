package github

import (
	"errors"
	"fmt"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/devauth"
	"idefix/operator"
	"idefix/trigger"
	"net/http"
)

// Client represents a minimal GitHub client able to make OAuth2.0 authenticated requests.
type Client struct {
	Requester *http.Client
	Operator  *operator.IdefixOperator
}

type params struct {
	user   string
	repo   string
	filter string
	state  string
}

// configure get credentials to connect to GitHub API
func (c *Client) configure() error {
	//TODO Credentials API
	c.Requester = devauth.GithubAuth()

	return nil
}

// parseParams get params of gRPC
func (c *Client) parseParams(prm *structpb.Struct) *params {
	return &params{
		user:   prm.Fields["user"].GetStringValue(),
		repo:   prm.Fields["repo"].GetStringValue(),
		filter: prm.Fields["filter"].GetStringValue(),
		state:  prm.Fields["state"].GetStringValue(),
	}
}

// preprocessIssue initialize action before get data
func (c *Client) preprocessIssue(prm *structpb.Struct) (*Issues, error) {
	var issues Issues

	p := c.parseParams(prm)

	if err := c.configure(); err != nil {
		return nil, fmt.Errorf("failed to configure github client: %w", err)
	}

	url := fmt.Sprintf("https://api.github.com/repos/%s/%s/issues?filter=%s&state=%s", p.user, p.repo, p.filter, p.state)
	get, err := c.Requester.Get(url)

	if err != nil {
		return nil, fmt.Errorf("failed to get issues from github: %w", err)
	}

	data, err := trigger.ReadBody(get)
	if err != nil {
		return nil, fmt.Errorf("failed to read body: %w", err)
	}

	if err = issues.Parse(data); err != nil {
		return nil, fmt.Errorf("failed to parse body: %w", err)
	}

	return &issues, nil
}

// PrOpen check if new pull-request is open
func (c *Client) NewPrDetected(taskID string, prm *structpb.Struct) error {
	issues, err := c.preprocessIssue(prm)
	if err != nil {
		return fmt.Errorf("failed to preprecess issue: %w", err)
	}

	old, err := issues.GetRedisState(c.Operator.RC, taskID, true)
	if err != nil {
		if errors.Is(err, ErrNoIssues) {
			return nil
		}

		return fmt.Errorf("failed to update redis state: %w", err)
	}

	err = issues.LookForChange(c.Operator, taskID, old, true)
	if err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}

// IssueOpen check if new issue is open
func (c *Client) NewIssueDetected(taskID string, prm *structpb.Struct) error {
	issues, err := c.preprocessIssue(prm)
	if err != nil {
		return fmt.Errorf("failed to preprecess issue: %w", err)
	}

	old, err := issues.GetRedisState(c.Operator.RC, taskID, false)
	if err != nil {
		if errors.Is(err, ErrNoIssues) {
			return nil
		}

		return fmt.Errorf("failed to update redis state: %w", err)
	}

	if err = issues.LookForChange(c.Operator, taskID, old, false); err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}

func (c *Client) NewAssignationDetected(taskID string, prm *structpb.Struct) error {
	if err := c.NewIssueDetected(taskID, prm); err != nil {
		return fmt.Errorf("failed to call new issue detected: %w", err)
	}

	return nil
}

func (c *Client) NewIssueClosedDetected(taskID string, prm *structpb.Struct) error {
	if err := c.NewIssueDetected(taskID, prm); err != nil {
		return fmt.Errorf("failed to call new issue detected: %w", err)
	}

	return nil
}
