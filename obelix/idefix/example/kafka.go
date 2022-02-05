package example

import (
	"encoding/json"
	"fmt"
	"idefix/producer"
	"os"
)

type Order struct {
	Pizza string `json:"pizza"`
	Table int    `json:"table"`
}

func ExampleKafka() error {
	p, err := producer.New()
	if err != nil {
		fmt.Println("error1", err.Error())
		os.Exit(1)
	}

	pizza, _ := json.Marshal(Order{"margarita", 17})

	msg := producer.PreparePublish("ntm", pizza)
	part, o, err := p.SendMessage(msg)
	if err != nil {
		return fmt.Errorf("send kafka failed %v", err)
	}

	fmt.Println("Partition: ", part)
	fmt.Println("Offset: ", o)
	return nil
}
