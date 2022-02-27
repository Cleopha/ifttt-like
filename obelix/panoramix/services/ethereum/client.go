package ethereum

import (
	"context"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/credentials"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/umbracle/go-web3"
	"github.com/umbracle/go-web3/jsonrpc"
	"github.com/umbracle/go-web3/wallet"
	"go.uber.org/zap"
	"google.golang.org/protobuf/types/known/structpb"
	"math/big"
	"os"
)

type Client struct {
	ctx        context.Context
	clt        *jsonrpc.Client
	privateKey string
}

func NewClient(ctx context.Context) *Client {
	return &Client{
		ctx: ctx,
	}
}

func (c *Client) configure(owner string) error {
	clt, err := jsonrpc.NewClient(os.Getenv("INFURA_ENDPOINT"))
	if err != nil {
		return fmt.Errorf("failed to create JSON RPC ethereum client: %w", err)
	}

	c.clt = clt

	credentialsClient, err := credentials.NewClient(os.Getenv("CREDENTIAL_API_PORT"))
	if err != nil {
		return fmt.Errorf("failed to create gRPC client: %w", err)
	}

	creds, err := credentialsClient.GetCredential(c.ctx, &protos.GetCredentialRequest{
		Owner:   owner,
		Service: 5,
	})
	if err != nil {
		return fmt.Errorf("failed to get ethereum credentials: %w", err)
	}

	c.privateKey = creds.GetToken()

	return nil
}

func (c *Client) SendTransaction(p *structpb.Struct, owner string) error {
	type paramsTransaction struct {
		from     web3.Address
		to       web3.Address
		value    *big.Int
		gasPrice uint64
	}

	params := paramsTransaction{
		from:     web3.HexToAddress(p.Fields["from"].GetStringValue()),
		to:       web3.HexToAddress(p.Fields["to"].GetStringValue()),
		value:    big.NewInt(int64(p.Fields["value"].GetNumberValue())),
		gasPrice: uint64(p.Fields["gasPrice"].GetNumberValue()),
	}

	if err := c.configure(owner); err != nil {
		return fmt.Errorf("failed to configure ethereum client: %w", err)
	}

	nonce, err := c.clt.Eth().GetNonce(params.from, web3.Latest)
	if err != nil {
		return fmt.Errorf("failed to get nonce: %w", err)
	}

	ecdsa, err := crypto.HexToECDSA(c.privateKey)
	if err != nil {
		return fmt.Errorf("failed to construct private key: %w", err)
	}

	key := wallet.NewKey(ecdsa)

	signer := wallet.NewEIP155Signer(3)
	tx, err := signer.SignTx(&web3.Transaction{
		From:     params.from,
		To:       &params.to,
		Value:    params.value,
		Nonce:    nonce,
		GasPrice: params.gasPrice,
		Gas:      1000000,
	}, key)
	if err != nil {
		return fmt.Errorf("failed to sign txn: %w", err)
	}

	hash, err := c.clt.Eth().SendTransaction(tx)
	if err != nil {
		return fmt.Errorf("failed to send transaction: %w", err)
	}

	zap.S().Info("Transaction has been submitted, available here: https://etherscan.io/tx/", hash)

	return nil
}
