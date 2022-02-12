package main

import (
	"context"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"log"
	"panoramix/cli"
	"panoramix/configuration"
	"panoramix/services/google"
)

func main() {
	ctx := context.Background()
	cliFlags := cli.Parse()

	conf, err := configuration.ExtractConfiguration(cliFlags.ConfigurationPath)
	if err != nil {
		log.Fatalln(err)
	}

	gclient, err := google.New(ctx, conf.GoogleScopes)
	if err != nil {
		log.Fatalln(err)
	}

	d := dispatcher.New()
	if err := d.Register("google", gclient); err != nil {
		log.Fatalln(err)
	}

	if _, err := d.Run("google", "CreateNewDocument", "MyDocumentTitle"); err != nil {
		log.Fatalln(err)
	}
}
