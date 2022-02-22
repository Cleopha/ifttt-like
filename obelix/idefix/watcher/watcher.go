package watcher

import (
	"context"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/common"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"idefix/services"
	"idefix/workflow"
	"log"
	"os"
	"strconv"
	"sync"
	"time"
)

var (
	TimeInterval    = ""
	WorkflowAPIPort = ""
)

func init() {
	TimeInterval = os.Getenv("TIME_INTERVAL")
	WorkflowAPIPort = os.Getenv("WORKFLOW_API_PORT")

	if TimeInterval == "" || WorkflowAPIPort == "" {
		log.Fatal(errors.New("watcher credentials are not set"))
	}
}

type Watcher struct {
	ctx      context.Context
	wg       sync.WaitGroup
	clt      *workflow.Client
	d        *dispatcher.Dispatcher
	Interval time.Duration
}

type Action struct {
	Type int
}

func New(ctx context.Context) (*Watcher, error) {
	client, err := workflow.NewClient(WorkflowAPIPort)
	if err != nil {
		return nil, fmt.Errorf("failed to create grpc client: %w", err)
	}

	d, err := services.RegisterServices(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to register services: %w", err)
	}

	t, err := strconv.Atoi(TimeInterval)
	if err != nil {
		return nil, fmt.Errorf("failed to format time interval: %w", err)
	}

	return &Watcher{
		ctx:      ctx,
		clt:      client,
		d:        d,
		Interval: time.Duration(t) * time.Second,
	}, nil
}

/*
func (w *Watcher) RunGCalendar() error {
	var gc google.GCalendar

	srv, err := calendar.NewService(context.Background(), option.WithHTTPClient(w.Requester))
	if err != nil {
		log.Fatalf("Unable to retrieve Calendar client: %v", err)
	}

	err = gc.Parse(srv)
	if err != nil || !errors.Is(err, google.ErrNoUpcomingEvent) {
		return fmt.Errorf("failed to parse gcalendar data: %w", err)
	}

	old, err := gc.GetRedisState(w.Operator.RC, "2")
	if err != nil {
		if errors.Is(err, github.ErrNoIssues) {
			return nil
		}

		return fmt.Errorf("failed to update redis state: %w", err)
	}

	err = gc.LookForChange(w.Operator, "2", old)
	if err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}
*/

func (w *Watcher) Watch() error {
	ticker := time.NewTicker(w.Interval)
	defer ticker.Stop()

	for {
		workflows, err := w.clt.ListWorkflows(w.ctx,
			&protos.ListWorkflowsRequest{Owner: "f1352b9d-3a91-496e-9179-ae9e32429d9a"})
		if err != nil {
			return fmt.Errorf("failed to get list of workflows: %w", err)
		}

		for _, elem := range workflows.Workflows {
			w.wg.Add(1)

			go func(elem *protos.Workflow) {
				defer w.wg.Done()

				for _, task := range elem.Tasks {
					if task.Type != protos.TaskType_ACTION {
						continue
					}

					taskID := task.Id

					service, method, params, err := common.ParseAction(task)
					if err != nil {
						// TODO: log error
						return
					}

					_, err = w.d.Run(service, method, taskID, params)
					if err != nil {
						fmt.Println(err)
						// TODO log error
						return
					}
				}
			}(elem)
		}

		<-ticker.C
	}
}
