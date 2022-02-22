package configuration

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
)

// Configuration represents the mandatory fields for the clients to run.
// For example, Google OAuth2.0 scopes are mandatory while running authenticated requests.
type Configuration struct {
	GoogleScopes []string `json:"google_scopes"`
}

// ExtractConfiguration reads the JSON configuration file and extract its values in a Configuration object.
func ExtractConfiguration(path string) (*Configuration, error) {
	conf := &Configuration{}

	// Read the file
	file, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("failed to read file: %w", err)
	}

	// Parse the JSON
	err = json.Unmarshal(file, conf)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal json: %w", err)
	}

	return conf, nil
}
