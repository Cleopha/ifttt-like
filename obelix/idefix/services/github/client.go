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

func (c *Client) configure() error {
	c.Requester = devauth.GithubAuth()

	return nil
}

func (c *Client) parseParams(prm *structpb.Struct) *params {
	return &params{
		user:   prm.Fields["user"].GetStringValue(),
		repo:   prm.Fields["repo"].GetStringValue(),
		filter: prm.Fields["filter"].GetStringValue(),
		state:  prm.Fields["state"].GetStringValue(),
	}
}

func (c *Client) preprocessIssue(taskID string, prm *structpb.Struct) (*Issues, error) {
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

	err = issues.Parse(data)
	if err != nil {
		return nil, fmt.Errorf("failed to parse body: %w", err)
	}

	return &issues, nil
}

func (c *Client) PrOpen(taskID string, prm *structpb.Struct) error {
	issues, err := c.preprocessIssue(taskID, prm)
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

func (c *Client) IssueOpen(taskID string, prm *structpb.Struct) error {
	issues, err := c.preprocessIssue(taskID, prm)
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
