package cli

import (
	"errors"
	"flag"
	"github.com/Cleopha/ifttt-like-common/logger"
)

var (
	ErrInvalidLogMode = errors.New("invalid logger mode")
)

// CLI represents all the flags needed for panoramix to run
type CLI struct {
	ConfigurationPath string
	LoggerMode        logger.Mode
}

// Parse parses the flags given to the panoramix
func Parse() (*CLI, error) {
	configurationPath := flag.String("configuration", "configuration.json", "")
	rawLogMode := flag.String("log", "dev", "")

	flag.Parse()

	var logMode logger.Mode

	switch *rawLogMode {
	case "dev":
		logMode = logger.Dev
	case "prod":
		logMode = logger.Prod
	default:
		return nil, ErrInvalidLogMode
	}

	return &CLI{
		ConfigurationPath: *configurationPath,
		LoggerMode:        logMode,
	}, nil
}
