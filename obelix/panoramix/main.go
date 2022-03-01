package main

import (
	"context"
	"github.com/Cleopha/ifttt-like-common/logger"
	"go.uber.org/zap"
	"log"
	"panoramix/cli"
	"panoramix/configuration"
	"panoramix/operator"
)

func main() {
	cliFlags, err := cli.Parse()
	if err != nil {
		log.Fatalln(err)
	}

	conf, err := configuration.ExtractConfiguration(cliFlags.ConfigurationPath)
	if err != nil {
		log.Fatalln(err)
	}

	if err = logger.InitLogger("logs", "panoramix_logs.txt", cliFlags.LoggerMode); err != nil {
		log.Fatalln(err)
	}

	ctx := context.Background()
	opr, err := operator.New(ctx, conf)

	if err != nil {
		zap.S().Fatal(err)
	}

	topics := []string{
		"google",
		"github",
		"scaleway",
	}

	if err = opr.ConsumeTopics(topics); err != nil {
		zap.S().Fatal(err)
	}
}
