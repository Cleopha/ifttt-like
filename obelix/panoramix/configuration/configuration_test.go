package configuration

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestExtractConfiguration(t *testing.T) {
	testCases := []struct {
		name         string
		path         string
		success      bool
		expectedConf *Configuration
	}{
		{
			name:    "Valid configuration file",
			path:    "../configuration.json",
			success: true,
			expectedConf: &Configuration{
				GoogleScopes: []string{
					"https://www.googleapis.com/auth/bigquery",
					"https://www.googleapis.com/auth/blogger",
				},
			},
		},
		{
			name:         "Non-existing configuration file",
			path:         "",
			success:      false,
			expectedConf: nil,
		},
	}

	for _, tt := range testCases {
		t.Run(tt.name, func(t *testing.T) {
			conf, err := ExtractConfiguration(tt.path)

			if tt.success {
				assert.NoError(t, err)
			} else {
				assert.Error(t, err)
			}
			assert.Equal(t, tt.expectedConf, conf)
		})
	}
}
