package redis

import (
	"context"
	"errors"
	"fmt"
	redisv8 "github.com/go-redis/redis/v8"
	"log"
	"os"
)

var addr string
var pass string

func init() {
	addr = os.Getenv("REDIS_ADDR")
	pass = os.Getenv("REDIS_PASS")

	if addr == "" || pass == "" {
		log.Fatal(errors.New("redis credentials are not set"))
	}
}

type Client struct {
	ctx context.Context
	rdb *redisv8.Client
}

func NewClient(ctx context.Context) *Client {
	rdb := redisv8.NewClient(&redisv8.Options{
		Addr:     addr,
		Password: pass,
		DB:       0, // use default DB
	})

	return &Client{ctx: ctx, rdb: rdb}
}

func (client *Client) SetKey(key, value string) error {
	err := client.rdb.Set(client.ctx, key, value, 0).Err()
	if err != nil {
		return fmt.Errorf("failed to set key: %w", err)
	}

	return nil
}

func (client *Client) GetKey(key string) (string, error) {
	value, err := client.rdb.Get(client.ctx, key).Result()
	if errors.Is(err, redisv8.Nil) {
		return "", redisv8.Nil
	}

	if err != nil {
		return "", fmt.Errorf("failed to get key: %w", err)
	}

	return value, nil
}
