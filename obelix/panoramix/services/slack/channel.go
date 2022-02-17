package slack

import (
	"context"
	"fmt"
	"net/http"
)

//nolint:structcheck,unused
type Client struct {
	ctx context.Context
	clt *http.Client
}

func (c *Client) CreateNewChannel(name string) {
	fmt.Println("Call from CreateNewChannel: ", name)
}
