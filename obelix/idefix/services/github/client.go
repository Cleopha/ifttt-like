package github

import (
	"context"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"go.uber.org/zap"
	"golang.org/x/oauth2"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/operator"
	"idefix/trigger"
	"log"
	"net/http"
	"os"
)

var (
	ClientID     = ""
	ClientSecret = ""
)

func init() {
	ClientID = os.Getenv("GITHUB_CLIENT_ID")
	ClientSecret = os.Getenv("GITHUB_CLIENT_SECRET")

	if ClientID == "" || ClientSecret == "" {
		log.Fatal(errors.New("github credentials are not set"))
	}
}

// Client represents a minimal GitHub client able to make OAuth2.0 authenticated requests.
type Client struct {
	ctx       context.Context
	Requester *http.Client
	Operator  *operator.IdefixOperator
}

func NewClient(ctx context.Context, op *operator.IdefixOperator) *Client {
	return &Client{
		ctx:       ctx,
		Requester: nil,
		Operator:  op,
	}
}

type params struct {
	user   string
	repo   string
	filter string
	state  string
}

// configure get credentials to connect to GitHub API
func (c *Client) configure(owner string) error {
	/*
		//TODO Credentials API
		c.Requester = devauth.GithubAuth()
	*/

	conf := &oauth2.Config{
		ClientID:     ClientID,
		ClientSecret: ClientSecret,
		Scopes:       []string{"user", "repo"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://github.com/login/oauth/authorize",
			TokenURL: "https://github.com/login/oauth/access_token",
		},
	}
	token := &oauth2.Token{}

	credentialClient, err := credentials.NewClient("9001")
	if err != nil {
		return fmt.Errorf("failed to create gRPC credential client: %w", err)
	}

	credential, err := credentialClient.GetCredential(c.ctx, &protos.GetCredentialRequest{
		Owner:   owner,
		Service: protos.Service_GITHUB,
	})
	if err != nil {
		return fmt.Errorf("failed to query GitHub credential: %w", err)
	}

	token.AccessToken = credential.GetToken()
	c.Requester = conf.Client(c.ctx, token)

	zap.S().Info("client configured")
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
func (c *Client) preprocessIssue(prm *structpb.Struct, owner string) (*Issues, error) {
	var issues Issues

	p := c.parseParams(prm)

	if err := c.configure(owner); err != nil {
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

// NewPrDetected check if new pull-request is open
func (c *Client) NewPrDetected(taskID string, prm *structpb.Struct, owner string) error {
	/*
		issues, err := c.preprocessIssue(prm, owner)
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

		err = issues.LookForChange(c.Operator, taskID, old, true, owner)
		if err != nil {
			return fmt.Errorf("an error has occurred while looking for changes: %w", err)
		}

	*/
	return nil
}

// NewIssueDetected check if new issue is open
func (c *Client) NewIssueDetected(taskID string, prm *structpb.Struct, owner string) error {
	issues, err := c.preprocessIssue(prm, owner)
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

	if err = issues.LookForChange(c.Operator, taskID, old, false, owner); err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}

func (c *Client) NewAssignationDetected(taskID string, prm *structpb.Struct, owner string) error {
	if err := c.NewIssueDetected(taskID, prm, owner); err != nil {
		return fmt.Errorf("failed to call new issue detected: %w", err)
	}

	return nil
}

func (c *Client) NewIssueClosedDetected(taskID string, prm *structpb.Struct, owner string) error {
	if err := c.NewIssueDetected(taskID, prm, owner); err != nil {
		return fmt.Errorf("failed to call new issue detected: %w", err)
	}

	return nil
}
