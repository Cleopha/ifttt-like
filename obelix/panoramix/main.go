package main

import (
	"context"
	"log"
	"panoramix/cli"
	"panoramix/configuration"
	"panoramix/services"
	"time"
)

func main() {
	ctx := context.Background()
	cliFlags := cli.Parse()

	conf, err := configuration.ExtractConfiguration(cliFlags.ConfigurationPath)
	if err != nil {
		log.Fatalln(err)
	}

	d, err := services.RegisterServices(ctx, conf)
	if err != nil {
		log.Fatalln(err)
	}

	if _, err := d.Run("google", "CreateNewEvent", "New test Event", time.Now().Add(time.Second*30),
		time.Minute*15); err != nil {
		log.Fatalln(err)
	}
}
