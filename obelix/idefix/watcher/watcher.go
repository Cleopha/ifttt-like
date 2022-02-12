package watcher

import (
	"context"
	"errors"
	"fmt"
	"google.golang.org/api/calendar/v3"
	"google.golang.org/api/option"
	"idefix/operator"
	"idefix/services/github"
	"idefix/services/google"
	"idefix/trigger"
	"log"
	"net/http"
	"sync"
	"time"
)

type Watcher struct {
	wg        sync.WaitGroup
	Requester *http.Client
	Operator  *operator.IdefixOperator
	Interval  time.Duration
}

const (
	GITHUB = iota
	DISCORD
)

type Action struct {
	Type int
}

func (w *Watcher) RunGithubIssue() error {
	var issues github.Issues
	get, err := w.Requester.Get("https://api.github.com/repos/Cleopha/ifttt-like-test/issues?filter=repos&state=all")
	if err != nil {
		return fmt.Errorf("failed to get issues from github: %v", err)
	}

	data, err := trigger.ReadBody(get)
	if err != nil {
		return fmt.Errorf("failed to read body: %v", err)
	}

	err = issues.Parse(data)
	if err != nil {
		return fmt.Errorf("failed to parse body: %v", err)
	}

	old, err := issues.GetRedisState(w.Operator.RC, "1")
	if err != nil {
		if errors.Is(err, github.ErrNoIssues) {
			return nil
		}
		return fmt.Errorf("failed to update redis state: %v", err)
	}

	err = issues.LookForChange(w.Operator, "1", old)
	if err != nil {
		return fmt.Errorf("an error has occured while looking for changes: %v", err)
	}

	return nil
}

func (w *Watcher) RunGCalendar() error {
	var gc google.GCalendar
	srv, err := calendar.NewService(context.Background(), option.WithHTTPClient(w.Requester))
	if err != nil {
		log.Fatalf("Unable to retrieve Calendar client: %v", err)
	}

	err = gc.Parse(srv)
	if err != nil {
		return fmt.Errorf("failed to parse gcalendar data: %v", err)
	}

	old, err := gc.GetRedisState(w.Operator.RC, "2")
	if err != nil {
		if errors.Is(err, github.ErrNoIssues) {
			return nil
		}
		return fmt.Errorf("failed to update redis state: %v", err)
	}

	err = gc.LookForChange(w.Operator, "2", old)
	if err != nil {
		return fmt.Errorf("an error has occured while looking for changes: %v", err)
	}

	return nil
}

func (w *Watcher) Watch() error {
	ticker := time.NewTicker(w.Interval)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			err := w.RunGCalendar()
			if err != nil {
				return fmt.Errorf("failed to run: %v", err)
			}
		}
	}
}
