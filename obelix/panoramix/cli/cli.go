package cli

import "flag"

// CLI represents all the flags needed for panoramix to run
type CLI struct {
	ConfigurationPath string
}

// Parse parses the flags given to the panoramix
func Parse() *CLI {
	configurationPath := flag.String("configuration", "configuration.json", "")

	flag.Parse()

	return &CLI{ConfigurationPath: *configurationPath}
}
