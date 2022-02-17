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

func (c *Client) SetKey(key, value string) error {
	err := c.rdb.Set(c.ctx, key, value, 0).Err()
	if err != nil {
		return fmt.Errorf("failed to set key: %w", err)
	}

	return nil
}

func (c *Client) GetKey(key string) (string, error) {
	value, err := c.rdb.Get(c.ctx, key).Result()
	if errors.Is(err, redisv8.Nil) {
		return "", redisv8.Nil
	}

	if err != nil {
		return "", fmt.Errorf("failed to get key: %w", err)
	}

	return value, nil
}

func (c *Client) UpdateRedisState(key, newer string) error {
	if err := c.SetKey(key, newer); err != nil {
		return fmt.Errorf("failed to set key in redis: %w", err)
	}

	return nil
}
