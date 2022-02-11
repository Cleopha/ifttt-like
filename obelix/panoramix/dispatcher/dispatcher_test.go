package dispatcher

import (
	"github.com/stretchr/testify/assert"
	"panoramix/services/google"
	"panoramix/services/slack"
	"testing"
)

func newDevDispatcher() *Dispatcher {
	return &Dispatcher{
		serviceMap: make(map[string]*funcData),
	}
}

func TestDispatcher_Register(t *testing.T) {
	testCases := []struct {
		name        string
		success     bool
		service     interface{}
		serviceName string
	}{
		{
			name:        "Can register a valid service",
			success:     true,
			service:     &google.Client{},
			serviceName: "google",
		},
		{
			name:        "Cannot register a non pointer to struct",
			success:     false,
			service:     google.Client{},
			serviceName: "google",
		},
	}

	for _, tt := range testCases {
		t.Run(tt.name, func(t *testing.T) {
			d := newDevDispatcher()

			err := d.register(tt.serviceName, tt.service)
			if tt.success {
				assert.NoError(t, err)
			} else {
				assert.Error(t, err)
			}
		})
	}
}

func TestDispatcher_Run(t *testing.T) {
	testCases := []struct {
		name          string
		success       bool
		service       interface{}
		serviceName   string
		methodName    string
		args          []interface{}
		expectedError error
	}{
		{
			name:          "Can run a valid service method",
			success:       true,
			service:       &google.Client{},
			serviceName:   "google",
			methodName:    "CreateNewDocument",
			args:          []interface{}{"NewDocumentTitle"},
			expectedError: nil,
		},
		{
			name:          "Cannot run due to invalid number of arguments - too many",
			success:       false,
			service:       &google.Client{},
			serviceName:   "google",
			methodName:    "CreateNewDocument",
			args:          []interface{}{"NewDocumentTitle", "Test"},
			expectedError: ErrInvalidNumberOfArguments,
		},
		{
			name:          "Cannot run due to invalid number of arguments - not enough",
			success:       false,
			service:       &google.Client{},
			serviceName:   "google",
			methodName:    "CreateNewDocument",
			args:          []interface{}{},
			expectedError: ErrInvalidNumberOfArguments,
		},
		{
			name:          "Cannot run due to invalid argument type",
			success:       false,
			service:       &google.Client{},
			serviceName:   "google",
			methodName:    "CreateNewDocument",
			args:          []interface{}{42},
			expectedError: ErrInvalidArgumentType,
		},
	}

	for _, tt := range testCases {
		t.Run(tt.name, func(t *testing.T) {
			d := newDevDispatcher()

			err := d.register(tt.serviceName, tt.service)
			if err != nil {
				t.Fatal(err)
			}

			err = d.Run(tt.serviceName, tt.methodName, tt.args...)

			if tt.success {
				assert.NoError(t, err)
			} else {
				assert.Error(t, err)
				assert.Equal(t, err, tt.expectedError)
			}
		})
	}
}

func TestDispatcher_RunMultiService(t *testing.T) {
	d := newDevDispatcher()

	// Register 2 services
	if err := d.register("google", &google.Client{}); err != nil {
		t.Fatal(err)
	}
	if err := d.register("slack", &slack.Client{}); err != nil {
		t.Fatal(err)
	}

	testCases := []struct {
		name        string
		success     bool
		serviceName string
		methodName  string
		args        []interface{}
	}{
		{
			name:        "Can run a google method",
			success:     true,
			serviceName: "google",
			methodName:  "CreateNewDocument",
			args:        []interface{}{"NewDocumentTitle"},
		},
		{
			name:        "Can run a slack method",
			success:     true,
			serviceName: "slack",
			methodName:  "CreateNewChannel",
			args:        []interface{}{"NewChannelName"},
		},
	}

	for _, tt := range testCases {
		t.Run(tt.name, func(t *testing.T) {
			err := d.Run(tt.serviceName, tt.methodName, tt.args...)

			if tt.success {
				assert.NoError(t, err)
			} else {
				assert.Error(t, err)
			}
		})
	}
}
