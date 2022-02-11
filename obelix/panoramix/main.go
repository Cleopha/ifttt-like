package main

import (
	"context"
	"log"
	"panoramix/cli"
	"panoramix/configuration"
	"panoramix/dispatcher"
)

func main() {
	ctx := context.Background()
	cliFlags := cli.Parse()

	conf, err := configuration.ExtractConfiguration(cliFlags.ConfigurationPath)
	if err != nil {
		log.Fatalln(err)
	}

	d, err := dispatcher.NewDispatcher(ctx, conf)
	if err != nil {
		log.Fatalln(err)
	}

	err = d.Run("google", "CreateNewDocument", "MyDocumentTitle")
	if err != nil {
		log.Fatalln(err)
	}
}
