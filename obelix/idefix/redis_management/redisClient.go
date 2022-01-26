package redis_management

import (
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
)

type RClient interface {
	SetKey(string, string) error
	GetKey(string) (string, error)
}

type RedisClient struct {
	ctx context.Context
	rdb *redis.Client
}

func (client RedisClient) SetKey(key, value string) error {
	err := client.rdb.Set(client.ctx, key, value, 0).Err()
	if err != nil {
		return fmt.Errorf("failed to set key: %v", err)
	}
	return nil
}

func (client RedisClient) GetKey(key string) (string, error) {
	value, err := client.rdb.Get(client.ctx, key).Result()
	if err == redis.Nil {
		return "", fmt.Errorf("key does not exist: %v", err)
	} else if err != nil {
		return "", fmt.Errorf("failed to get key: %v", err)
	}
	return value, nil
}

func NewRedisClient(addr string) RedisClient {
	rdb := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	return RedisClient{ctx: context.Background(), rdb: rdb}
}
