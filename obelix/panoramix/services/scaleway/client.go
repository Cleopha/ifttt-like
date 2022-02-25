package scaleway

import (
	"context"
	"errors"
	"fmt"
	flexibleip "github.com/scaleway/scaleway-sdk-go/api/flexibleip/v1alpha1"
	"github.com/scaleway/scaleway-sdk-go/api/instance/v1"
	"github.com/scaleway/scaleway-sdk-go/scw"
	"go.uber.org/zap"
)

var (
	ErrDefaultProjectIDDoesNotExist = errors.New("default project ID not found")
	ErrInvalidServerCommercialType  = errors.New("can only DEV1-S and DEV1-M servers for money reasons")
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

// CreateNewInstance creates a new instance (either a DEV1-S or DEV1-M) with the given name in the specified zone.
func (c *Client) CreateNewInstance(projectID string, zone scw.Zone, name string, commercialType string) error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	if commercialType != "DEV1-S" && commercialType != "DEV1-M" {
		return ErrInvalidServerCommercialType
	}

	api := instance.NewAPI(c.clt)
	_, err := api.CreateServer(&instance.CreateServerRequest{
		Zone:           zone,
		Name:           name,
		CommercialType: commercialType,
		Project:        &projectID,
		Image:          "ubuntu_focal",
	})

	if err != nil {
		return fmt.Errorf("failed to create server: %w", err)
	}

	zap.S().Info("New server successfully created")

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
