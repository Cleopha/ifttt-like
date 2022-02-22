package main

import (
	"context"
	"log"
	"panoramix/operator"
)

func main() {
	ctx := context.Background()
	operator, err := operator.New(ctx)

	if err != nil {
		log.Fatalln(err)
	}

	topics := []string{
		"google",
		"github",
	}

	if err = operator.ConsumeTopics(topics); err != nil {
		log.Fatalln(err)
	}
}
