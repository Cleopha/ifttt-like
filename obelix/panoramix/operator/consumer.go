package operator

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"github.com/Shopify/sarama"
	"os"
	"panoramix/cli"
	"panoramix/configuration"
	"panoramix/protos"
	__ "panoramix/protos/protos"
	"panoramix/services"
	"sync"
)

var (
	ErrEmptyBrokerAddress = errors.New("kafka broker address cannot be empty")
)

type Operator struct {
	c   sarama.Consumer
	d   *dispatcher.Dispatcher
	wg  sync.WaitGroup
	ctx context.Context
}

// New creates a new Operator containing a sarama operator.
func New(ctx context.Context) (*Operator, error) {
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

	// Creates the services configuration
	cliFlags := cli.Parse()
	conf, err := configuration.ExtractConfiguration(cliFlags.ConfigurationPath)

	if err != nil {
		return nil, fmt.Errorf("failed to extract configuration: %w", err)
	}

	// Registers the services
	d, err := services.RegisterServices(ctx, conf)
	if err != nil {
		return nil, fmt.Errorf("failed to register services: %w", err)
	}

	return &Operator{
		c:   consumer,
		d:   d,
		ctx: ctx,
	}, nil
}

// getNextTask uses the workflow API to get the task following the action.
// It returns the next task's namespace, associated method name and parameters.
// e.g.: GOOGLE_CREATE_NEW_EVENT becomes google CreateNewEvent with its associated parameters.
func (o *Operator) getNextTask(initialActionID string) (string, string, []interface{}, error) {
	client, err := protos.NewClient("9000")
	if err != nil {
		return "", "", nil, fmt.Errorf("failed to create new gRPC client: %w", err)
	}

	t, err := client.GetTask(o.ctx, &__.GetTaskRequest{Id: initialActionID})
	if err != nil {
		return "", "", nil, fmt.Errorf("failed to get current task: %w", err)
	}

	_, err = client.GetTask(o.ctx, &__.GetTaskRequest{Id: t.NextTask})
	if err != nil {
		return "", "", nil, fmt.Errorf("failed to get next task: %w", err)
	}

	// TODO: Use t.Action.String() to parse the namespace and method, retrieve the arguments and return them !

	return "google", "CreateNewDocument", []interface{}{
		"This is a new document",
	}, nil
}

// runWorkflow uses the action at the beginning of the workflow to execute the following reactions.
func (o *Operator) runWorkflow(a protos.Action) error {
	n, m, p, err := o.getNextTask(a.TaskID)
	if err != nil {
		return fmt.Errorf("failed to get next task from the Workflow API: %w", err)
	}

	if _, err = o.d.Run(n, m, p...); err != nil {
		return fmt.Errorf("failed to run reaction: %w", err)
	}

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
			a := protos.Action{}
			if err := json.Unmarshal(msg.Value, &a); err != nil {
				return fmt.Errorf("failed to decode kafka message: %w", err)
			}

			// Spawn one goroutine per workflow execution.
			wg.Add(1)

			go func() {
				defer wg.Done()

				if err := o.runWorkflow(a); err != nil {
					fmt.Fprintln(os.Stderr, err)
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

			if err := o.consumeService(t); err != nil {
				fmt.Fprint(os.Stderr, err)
			}
		}(topic)
	}

	return nil
}
