package main

import (
	"context"
	"github.com/Cleopha/ifttt-like-common/logger"
	"go.uber.org/zap"
	"idefix/watcher"
	"log"
)

func main() {
	if err := logger.InitLogger("logs", "idefix_logs.txt", logger.Dev); err != nil {
		log.Fatalln(err)
	}

	ctx := context.Background()
	w, err := watcher.New(ctx)

	if err != nil {
		zap.S().Fatal(err)
	}

	//nolint:nolintlint,staticcheck
	if err := w.Watch(); err != nil {
		zap.S().Fatal(err)
	}
}
