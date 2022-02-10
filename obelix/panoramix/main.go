package main

import (
	"context"
	"log"
	"panoramix/dispatcher"
)

func main() {
	ctx := context.Background()
	err := dispatcher.Run(ctx)
	if err != nil {
		log.Fatalln(err)
	}
}
