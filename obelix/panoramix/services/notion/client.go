package notion

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/jomei/notionapi"
	"go.uber.org/zap"
	"google.golang.org/protobuf/types/known/structpb"
	"os"
)

var (
	CredentialAPIHost = ""
	CredentialAPIPort = ""
)

var (
	ErrNoParentFound         = errors.New("no parent found")
	ErrCredentialAPINotFound = errors.New("credentials API not set")
)

func init() {
	CredentialAPIHost = os.Getenv("CREDENTIAL_API_HOST")
	CredentialAPIPort = os.Getenv("CREDENTIAL_API_PORT")

	if CredentialAPIHost == "" || CredentialAPIPort == "" {
		zap.S().Fatal(ErrCredentialAPINotFound)
	}
}

type Client struct {
	ctx context.Context
	clt *notionapi.Client
}

func New(ctx context.Context) *Client {
	return &Client{
		ctx: ctx,
		clt: nil,
	}
}

func (c *Client) configure(owner string) error {
	credentialClient, err := credentials.NewClient(CredentialAPIHost, CredentialAPIPort)
	if err != nil {
		return fmt.Errorf("failed to create gRPC credential client: %w", err)
	}

	credential, err := credentialClient.GetCredential(c.ctx, &protos.GetCredentialRequest{
		Owner:   owner,
		Service: protos.Service_NOTION,
	})
	if err != nil {
		return fmt.Errorf("failed to get notion credential: %w", err)
	}

	c.clt = notionapi.NewClient(notionapi.Token(credential.GetToken()))

	return credentialClient.Shutdown()
}

func (c *Client) CreateNewPage(p *structpb.Struct, owner string) error {
	type paramsNewPage struct {
		from  string
		title string
	}

	params := paramsNewPage{
		from:  p.Fields["from"].GetStringValue(),
		title: p.Fields["title"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure notion client: %w", err)
	}

	// 1. Look for the parent page.
	searchResponse, err := c.clt.Search.Do(c.ctx, &notionapi.SearchRequest{
		Query: params.from,
	})
	if err != nil {
		return fmt.Errorf("failed to search for parent page: %w", err)
	}

	if len(searchResponse.Results) == 0 {
		return ErrNoParentFound
	}

	type parent struct {
		ID string `json:"ID"`
	}

	var page parent

	data, err := json.Marshal(searchResponse.Results[0])
	if err != nil {
		return fmt.Errorf("failed to process response: %w", err)
	}

	err = json.Unmarshal(data, &page)
	if err != nil {
		return fmt.Errorf("failed to extract page ID: %w", err)
	}

	// 2. Create the child.
	_, err = c.clt.Page.Create(c.ctx, &notionapi.PageCreateRequest{
		Parent: notionapi.Parent{
			Type:   "page_id",
			PageID: notionapi.PageID(page.ID),
		},
		Properties: notionapi.Properties{
			"title": notionapi.TitleProperty{
				Title: []notionapi.RichText{
					{
						Text: notionapi.Text{
							Content: params.title,
						},
					},
				},
			},
		},
		Children: nil,
	})
	if err != nil {
		return fmt.Errorf("failed to create notion page: %w", err)
	}

	zap.S().Info("Notion page successfully created")

	return nil
}
