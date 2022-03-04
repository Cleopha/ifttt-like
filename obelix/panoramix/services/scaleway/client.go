package scaleway

import (
	"context"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	flexibleip "github.com/scaleway/scaleway-sdk-go/api/flexibleip/v1alpha1"
	"github.com/scaleway/scaleway-sdk-go/api/instance/v1"
	"github.com/scaleway/scaleway-sdk-go/api/k8s/v1"
	"github.com/scaleway/scaleway-sdk-go/api/rdb/v1"
	"github.com/scaleway/scaleway-sdk-go/api/registry/v1"
	"github.com/scaleway/scaleway-sdk-go/scw"
	"go.uber.org/zap"
	"google.golang.org/protobuf/types/known/structpb"
	"os"
	"strings"
)

var (
	CredentialAPIHost = ""
	CredentialAPIPort = ""
)

var (
	ErrInvalidServerCommercialType      = errors.New("can only DEV1-S and DEV1-M servers for money reasons")
	ErrInvalidDatabaseInstanceEngine    = errors.New("only support PostgreSQL-14 and MySQL-8")
	ErrInvalidScalewayCredentialsFormat = errors.New("invalid scaleway credentials format")
	ErrCredentialAPINotFound            = errors.New("credentials API not set")
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
func (c *Client) configure(owner string) error {
	credentialClient, err := credentials.NewClient(CredentialAPIHost, CredentialAPIPort)
	if err != nil {
		return fmt.Errorf("failed to create gRPC credential client: %w", err)
	}

	creds, err := credentialClient.GetCredential(c.ctx, &protos.GetCredentialRequest{
		Owner:   owner,
		Service: protos.Service_SCALEWAY,
	})
	if err != nil {
		return fmt.Errorf("failed to get scaleway credentials: %w", err)
	}

	// Scaleway credentials are stored using the following format: secretKey + accessKey
	// with the access key beginning by "SCW"
	keys := strings.Split(creds.GetToken(), "SCW")

	if len(keys) != 2 {
		return ErrInvalidScalewayCredentialsFormat
	}

	c.clt, err = scw.NewClient(scw.WithAuth("SCW"+keys[1], keys[0]))
	if err != nil {
		return fmt.Errorf("failed to create scaleway client: %w", err)
	}

	return credentialClient.Shutdown()
}

//nolint:stylecheck
// CreateNewFlexibleIp creates a new flexible IP in the fr-par-2 zone.
func (c *Client) CreateNewFlexibleIp(p *structpb.Struct, owner string) error {
	type paramsNewFlexibleIP struct {
		projectID string
	}

	params := paramsNewFlexibleIP{
		projectID: p.Fields["projectID"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	api := flexibleip.NewAPI(c.clt)
	_, err := api.CreateFlexibleIP(&flexibleip.CreateFlexibleIPRequest{
		Zone:      scw.ZoneFrPar2,
		ProjectID: params.projectID,
	})

	if err != nil {
		return fmt.Errorf("failed to create flexible IP: %w", err)
	}

	zap.S().Info("New flexible IP successfully created")

	return nil
}

// CreateNewInstance creates a new instance (either a DEV1-S or DEV1-M) with the given name in the specified zone.
func (c *Client) CreateNewInstance(p *structpb.Struct, owner string) error {
	type paramsNewInstance struct {
		projectID      string
		zone           scw.Zone
		name           string
		commercialType string
	}

	params := paramsNewInstance{
		projectID:      p.Fields["projectID"].GetStringValue(),
		zone:           scw.Zone(p.Fields["zone"].GetStringValue()),
		name:           p.Fields["name"].GetStringValue(),
		commercialType: p.Fields["commercialType"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	if params.commercialType != "DEV1-S" && params.commercialType != "DEV1-M" {
		return ErrInvalidServerCommercialType
	}

	api := instance.NewAPI(c.clt)
	_, err := api.CreateServer(&instance.CreateServerRequest{
		Zone:           params.zone,
		Name:           params.name,
		CommercialType: params.commercialType,
		Project:        &params.projectID,
		Image:          "ubuntu_focal",
	})

	if err != nil {
		return fmt.Errorf("failed to create server: %w", err)
	}

	zap.S().Info("New server successfully created")

	return nil
}

func (c *Client) CreateNewDatabase(p *structpb.Struct, owner string) error {
	type paramsNewInstance struct {
		projectID string
		name      string
		username  string
		password  string
		engine    string
	}

	params := paramsNewInstance{
		projectID: p.Fields["projectID"].GetStringValue(),
		name:      p.Fields["name"].GetStringValue(),
		username:  p.Fields["username"].GetStringValue(),
		password:  p.Fields["password"].GetStringValue(),
		engine:    p.Fields["engine"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	if params.engine != "PostgreSQL-14" && params.engine != "MySQL-8" {
		return ErrInvalidDatabaseInstanceEngine
	}

	api := rdb.NewAPI(c.clt)
	_, err := api.CreateInstance(&rdb.CreateInstanceRequest{
		Region:    scw.RegionFrPar,
		ProjectID: &params.projectID,
		Name:      params.name,
		Engine:    params.engine,
		UserName:  params.username,
		Password:  params.password,
		NodeType:  "DB-DEV-S",
	})

	if err != nil {
		return fmt.Errorf("failed to create database instance: %w", err)
	}

	return nil
}

func (c *Client) CreateNewKubernetesCluster(p *structpb.Struct, owner string) error {
	type paramsNewK8S struct {
		projectID string
		name      string
		region    scw.Region
		cni       k8s.CNI
		ingress   k8s.Ingress
	}

	params := paramsNewK8S{
		projectID: p.Fields["projectID"].GetStringValue(),
		name:      p.Fields["name"].GetStringValue(),
		region:    scw.Region(p.Fields["region"].GetStringValue()),
		cni:       k8s.CNI(p.Fields["cni"].GetStringValue()),
		ingress:   k8s.Ingress(p.Fields["ingress"].GetStringValue()),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	api := k8s.NewAPI(c.clt)

	versions, err := api.ListVersions(&k8s.ListVersionsRequest{
		Region: params.region,
	})
	if err != nil {
		return fmt.Errorf("failed to get available k8s versions: %w", err)
	}

	_, err = api.CreateCluster(&k8s.CreateClusterRequest{
		Region:    params.region,
		ProjectID: &params.projectID,
		Name:      params.name,
		Version:   versions.Versions[0].Name,
		Cni:       params.cni,
		Ingress:   params.ingress,
	})
	if err != nil {
		return fmt.Errorf("failed to create k8s cluster: %w", err)
	}

	return nil
}

func (c *Client) CreateNewContainerRegistry(p *structpb.Struct, owner string) error {
	type paramsNewContainerRegistry struct {
		region    scw.Region
		name      string
		projectID string
	}

	params := paramsNewContainerRegistry{
		region:    scw.Region(p.Fields["region"].GetStringValue()),
		name:      p.Fields["name"].GetStringValue(),
		projectID: p.Fields["projectID"].GetStringValue(),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	api := registry.NewAPI(c.clt)
	_, err := api.CreateNamespace(&registry.CreateNamespaceRequest{
		Region:    params.region,
		Name:      params.name,
		ProjectID: &params.projectID,
	})

	if err != nil {
		return fmt.Errorf("failed to create container registry: %w", err)
	}

	return nil
}
