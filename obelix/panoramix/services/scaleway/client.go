package scaleway

import (
	"context"
	"errors"
	"fmt"
	flexibleip "github.com/scaleway/scaleway-sdk-go/api/flexibleip/v1alpha1"
	"github.com/scaleway/scaleway-sdk-go/scw"
	"go.uber.org/zap"
)

var (
	ErrDefaultProjectIDDoesNotExist = errors.New("default project ID not found")
)

type Client struct {
	ctx context.Context
	clt *scw.Client
}

// New creates a new Scaleway client.
func New(ctx context.Context) *Client {
	return &Client{
		ctx: ctx,
	}
}

// configure uses the credentialAPI to retrieve the user's access and secret keys used when making queries to the
// Scaleway services.
func (c *Client) configure() error {
	var err error

	accessKey, secretKey := GetKeys()

	c.clt, err = scw.NewClient(scw.WithAuth(accessKey, secretKey))
	if err != nil {
		return fmt.Errorf("failed to create scaleway client: %w", err)
	}

	return nil
}

//nolint:stylecheck
// CreateNewFlexibleIp creates a new flexible IP in the fr-par-2 zone.
func (c *Client) CreateNewFlexibleIp(projectID string) error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	api := flexibleip.NewAPI(c.clt)
	_, err := api.CreateFlexibleIP(&flexibleip.CreateFlexibleIPRequest{
		Zone:      scw.ZoneFrPar2,
		ProjectID: projectID,
	})

	if err != nil {
		return fmt.Errorf("failed to create flexible IP: %w", err)
	}

	zap.S().Info("New flexible IP successfully created")

	return nil
}

func (c *Client) CreateNewInstance() error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	return nil
}

func (c *Client) CreateNewDatabase() error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	return nil
}

func (c *Client) CreateNewKubernetesCluster() error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	return nil
}

func (c *Client) CreateNewContainerRegistry() error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	return nil
}
