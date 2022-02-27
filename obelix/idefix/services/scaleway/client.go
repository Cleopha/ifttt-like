package scaleway

import (
	"context"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/scaleway/scaleway-sdk-go/api/instance/v1"
	"github.com/scaleway/scaleway-sdk-go/scw"
	"go.uber.org/zap"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/operator"
	"os"
	"strings"
)

var (
	ErrInvalidScalewayCredentialsFormat = errors.New("invalid scaleway credentials format")
)

type Client struct {
	ctx      context.Context
	clt      *scw.Client
	Operator *operator.IdefixOperator
}

func NewClient(ctx context.Context, op *operator.IdefixOperator) *Client {
	return &Client{
		ctx:      ctx,
		clt:      nil,
		Operator: op,
	}
}

func (c *Client) configure(owner string) error {
	credentialClient, err := credentials.NewClient(os.Getenv("CREDENTIAL_API_PORT"))
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

	clt, err := scw.NewClient(scw.WithAuth("SCW"+keys[1], keys[0]))
	if err != nil {
		return fmt.Errorf("failed to create scaleway client: %w", err)
	}

	c.clt = clt

	return nil
}

func (c *Client) VolumeExceedsLimit(taskID string, prm *structpb.Struct, owner string) error {
	type params struct {
		zone  scw.Zone
		limit uint32
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure scaleway client: %w", err)
	}

	p := params{
		zone:  scw.Zone(prm.Fields["zone"].GetStringValue()),
		limit: uint32(prm.Fields["zone"].GetNumberValue()),
	}

	v := Volume{
		Limit: p.limit,
	}

	api := instance.NewAPI(c.clt)
	volumes, err := api.ListVolumes(&instance.ListVolumesRequest{
		Zone: p.zone,
	})

	if err != nil {
		return fmt.Errorf("failed to query volumes: %w", err)
	}

	if err = v.Parse(volumes); err != nil {
		return fmt.Errorf("failed to parse volumes: %w", err)
	}

	old, err := v.GetRedisState(c.Operator.RC, taskID)
	if err != nil {
		return fmt.Errorf("failed to retrieve redis state: %w", err)
	}

	if err = v.LookForChange(c.Operator, taskID, old, owner); err != nil {
		zap.S().Info(err)

		return fmt.Errorf("an error has occurred while looking for change between states: %w", err)
	}

	return nil
}
