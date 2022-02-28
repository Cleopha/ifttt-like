package ethereum

import (
	"context"
	"crypto/ecdsa"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"go.uber.org/zap"
	"google.golang.org/protobuf/types/known/structpb"
	"math/big"
	"os"
)

var (
	InfuraEndpoint     = ""
	CredentialEndpoint = ""
)

func init() {
	InfuraEndpoint = os.Getenv("INFURA_ENDPOINT")
	CredentialEndpoint = os.Getenv("CREDENTIAL_API_PORT")

	if InfuraEndpoint == "" {
		zap.S().Fatal("ethereum credentials are not set")
	}

	if CredentialEndpoint == "" {
		zap.S().Fatal("credential API configuration is not set")
	}
}

var (
	ErrFailedToConvertPublicKey = errors.New("failed to convert public key to valid format")
)

type Client struct {
	ctx        context.Context
	clt        *ethclient.Client
	privateKey *ecdsa.PrivateKey
}

func NewClient(ctx context.Context) *Client {
	return &Client{
		ctx: ctx,
	}
}

func (c *Client) configure(owner string) error {
	clt, err := ethclient.Dial(InfuraEndpoint)
	if err != nil {
		return fmt.Errorf("failed to create ethereum client: %w", err)
	}

	c.clt = clt

	credentialsClient, err := credentials.NewClient(CredentialEndpoint)
	if err != nil {
		return fmt.Errorf("failed to create gRPC client: %w", err)
	}

	creds, err := credentialsClient.GetCredential(c.ctx, &protos.GetCredentialRequest{
		Owner:   owner,
		Service: protos.Service_ETH,
	})
	if err != nil {
		return fmt.Errorf("failed to get ethereum credentials: %w", err)
	}

	rawPrivateKey := creds.GetToken()

	c.privateKey, err = crypto.HexToECDSA(rawPrivateKey)
	if err != nil {
		return fmt.Errorf("failed to extract private key: %w", err)
	}

	return credentialsClient.Shutdown()
}

func (c *Client) shutdown() {
	c.clt.Close()
}

func (c *Client) SendTransaction(p *structpb.Struct, owner string) error {
	type paramsSendTransaction struct {
		to    string
		value int64
	}

	defer c.shutdown()

	err := c.configure(owner)
	if err != nil {
		return fmt.Errorf("failed to run ethereum configuration: %w", err)
	}

	params := paramsSendTransaction{
		to:    p.Fields["to"].GetStringValue(),
		value: int64(p.Fields["value"].GetNumberValue()),
	}

	from, ok := c.privateKey.Public().(*ecdsa.PublicKey)
	if !ok {
		return ErrFailedToConvertPublicKey
	}

	nonce, err := c.clt.PendingNonceAt(c.ctx, crypto.PubkeyToAddress(*from))
	if err != nil {
		return fmt.Errorf("failed to get nonce: %w", err)
	}

	gasPrice, err := c.clt.SuggestGasPrice(c.ctx)
	if err != nil {
		return fmt.Errorf("failed to estimate gas price: %w", err)
	}

	var data []byte
	tx := types.NewTransaction(
		nonce, common.HexToAddress(params.to),
		big.NewInt(params.value),
		21000,
		gasPrice,
		data,
	)

	chainID, err := c.clt.NetworkID(c.ctx)
	if err != nil {
		return fmt.Errorf("failed to get chainID: %w", err)
	}

	signedTx, err := types.SignTx(tx, types.NewEIP155Signer(chainID), c.privateKey)
	if err != nil {
		return fmt.Errorf("failed to sign transaction: %w", err)
	}

	err = c.clt.SendTransaction(c.ctx, signedTx)
	if err != nil {
		return fmt.Errorf("failed to send transaction: %w", err)
	}

	address := crypto.PubkeyToAddress(*from)

	zap.S().Info("Transaction has been submitted, available here: https://ropsten.etherscan.io/address/", address)

	return nil
}
