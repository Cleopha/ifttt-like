package operator

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/common"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"github.com/Shopify/sarama"
	"go.uber.org/zap"
	"os"
	"panoramix/configuration"
	"panoramix/services"
	"panoramix/task"
	"sync"
)

var (
	ErrEmptyBrokerAddress           = errors.New("kafka broker address cannot be empty")
	ErrEmptyOutReactionRun          = errors.New("reaction run should have return a status")
	ErrFailedToExtractReactionError = errors.New("failed to extract reaction error")
)

type Operator struct {
	c   sarama.Consumer
	d   *dispatcher.Dispatcher
	wg  sync.WaitGroup
	ctx context.Context
}

// New creates a new Operator containing a sarama operator.
func New(ctx context.Context, conf *configuration.Configuration) (*Operator, error) {
	brokerAddress := os.Getenv("BROKER_ADDRESS")
	if brokerAddress == "" {
		return nil, ErrEmptyBrokerAddress
	}

	// Creates the sarama operator
	config := sarama.NewConfig()
	consumer, err := sarama.NewConsumer([]string{brokerAddress}, config)

	if err != nil {
		return nil, fmt.Errorf("failed to create sarama operator: %w", err)
	}

	zap.S().Info("Panoramix is connected to kafka")

	// Registers the services
	d, err := services.RegisterServices(ctx, conf)
	if err != nil {
		return nil, fmt.Errorf("failed to register services: %w", err)
	}

	zap.S().Info("Panoramix services are now loaded")

	return &Operator{
		c:   consumer,
		d:   d,
		ctx: ctx,
	}, nil
}

func (o *Operator) runReaction(t *protos.Task) error {
	service, method, params, err := common.ParseAction(t)
	if err != nil {
		return fmt.Errorf("failed to parse action: %w", err)
	}

	zap.S().Infof("Executing method %s from service %s", method, service)

	out, err := o.d.Run(service, method, params)

	if err != nil {
		return fmt.Errorf("failed to run reaction: %w", err)
	}

	if len(out) == 0 {
		return ErrEmptyOutReactionRun
	}

	// If the internal call has failed
	if !out[0].IsNil() {
		err, ok := out[0].Interface().(error)

		if !ok {
			return ErrFailedToExtractReactionError
		}

		if err != nil {
			return fmt.Errorf("failed to run method %s from server %s: %w", method, service, err)
		}
	}

	return nil
}

// runWorkflow uses the action at the beginning of the workflow to execute the following reactions.
func (o *Operator) runWorkflow(initialAction task.Action) error {
	// Creates the task client, used to retrieve a workflow's tasks one after the other.
	client, err := task.NewClient("9000")
	if err != nil {
		return fmt.Errorf("failed to create new gRPC client: %w", err)
	}

	t, err := client.GetTask(o.ctx, &protos.GetTaskRequest{Id: initialAction.TaskID})
	if err != nil {
		return fmt.Errorf("failed to get first reaction: %w", err)
	}

	zap.S().Info("Starting workflow execution", zap.String("task_id", t.Id))

	for t.NextTask != "" {
		t, err = client.GetTask(o.ctx, &protos.GetTaskRequest{Id: t.NextTask})
		if err != nil {
			return fmt.Errorf("failed to get reaction: %w", err)
		}

		if err = o.runReaction(t); err != nil {
			return fmt.Errorf("failed to run reaction: %w", err)
		}
	}

	zap.S().Info("Workflow execution is done", zap.String("task_id", t.Id))

	return nil
}

// consumeService reads all the messages pushed to the topic's queue.
// Then, it executes the reactions of the workflow in a new goroutine.
func (o *Operator) consumeService(topic string) error {
	var wg sync.WaitGroup
	defer wg.Wait()

	partitions, err := o.c.Partitions(topic)
	if err != nil {
		return fmt.Errorf("an error occurred while fetching partitions for topic %s: %w", topic, err)
	}

	// For each partition of the current topic, consume the incoming messages
	for _, partition := range partitions {
		p, err := o.c.ConsumePartition(topic, partition, sarama.OffsetNewest)
		if err != nil {
			return fmt.Errorf("failed to consume partition: %w", err)
		}

		messages := p.Messages()

		// Read all messages.
		for msg := range messages {
			a := task.Action{}
			if err := json.Unmarshal(msg.Value, &a); err != nil {
				return fmt.Errorf("failed to decode kafka message: %w", err)
			}

			// Spawn one goroutine per workflow execution.
			wg.Add(1)

			go func() {
				defer wg.Done()

				if err := o.runWorkflow(a); err != nil {
					zap.S().Errorf("Worflow failed to run: %s", err.Error())
				}
			}()
		}
	}

	return nil
}

// ConsumeTopics spawns one goroutine for each topic.
// Each one of them will consume the messages from the topic's partitions and execute the reactions.
func (o *Operator) ConsumeTopics(topics []string) error {
	defer o.wg.Wait()

	for _, topic := range topics {
		o.wg.Add(1)

		// Spawn one goroutine for the current topic
		go func(t string) {
			defer o.wg.Done()

			zap.S().Infof("Consuming topic %s", t)

			if err := o.consumeService(t); err != nil {
				zap.S().Errorf(err.Error())
			}
		}(topic)
	}

	return nil
}
