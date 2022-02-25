package scaleway

import (
	"context"
	"errors"
	"fmt"
	flexibleip "github.com/scaleway/scaleway-sdk-go/api/flexibleip/v1alpha1"
	"github.com/scaleway/scaleway-sdk-go/api/instance/v1"
	"github.com/scaleway/scaleway-sdk-go/api/k8s/v1"
	"github.com/scaleway/scaleway-sdk-go/api/rdb/v1"
	"github.com/scaleway/scaleway-sdk-go/api/registry/v1"
	"github.com/scaleway/scaleway-sdk-go/scw"
	"go.uber.org/zap"
)

var (
	ErrInvalidServerCommercialType   = errors.New("can only DEV1-S and DEV1-M servers for money reasons")
	ErrInvalidDatabaseInstanceEngine = errors.New("only support PostgreSQL-14 and MySQL-8")
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

func (c *Client) CreateNewDatabase(projectID, name, username, password, engine string) error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	if engine != "PostgreSQL-14" && engine != "MySQL-8" {
		return ErrInvalidDatabaseInstanceEngine
	}

	api := rdb.NewAPI(c.clt)
	_, err := api.CreateInstance(&rdb.CreateInstanceRequest{
		Region:    scw.RegionFrPar,
		ProjectID: &projectID,
		Name:      name,
		Engine:    engine,
		UserName:  username,
		Password:  password,
		NodeType:  "DB-DEV-S",
	})

	if err != nil {
		return fmt.Errorf("failed to create database instance: %w", err)
	}

	return nil
}

func (c *Client) CreateNewKubernetesCluster(projectID, name string, region scw.Region,
	cni k8s.CNI, ingress k8s.Ingress) error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	api := k8s.NewAPI(c.clt)

	versions, err := api.ListVersions(&k8s.ListVersionsRequest{
		Region: region,
	})
	if err != nil {
		return fmt.Errorf("failed to get available k8s versions: %w", err)
	}

	_, err = api.CreateCluster(&k8s.CreateClusterRequest{
		Region:    region,
		ProjectID: &projectID,
		Name:      name,
		Version:   versions.Versions[0].Name,
		Cni:       cni,
		Ingress:   ingress,
	})
	if err != nil {
		return fmt.Errorf("failed to create k8s cluster: %w", err)
	}

	return nil
}

func (c *Client) CreateNewContainerRegistry(region scw.Region, name string, projectID string) error {
	if err := c.configure(); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	api := registry.NewAPI(c.clt)
	_, err := api.CreateNamespace(&registry.CreateNamespaceRequest{
		Region:    region,
		Name:      name,
		ProjectID: &projectID,
	})

	if err != nil {
		return fmt.Errorf("failed to create container registry: %w", err)
	}

	return nil
}
