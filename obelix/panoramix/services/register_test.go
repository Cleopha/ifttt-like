package services

import (
	"context"
	"github.com/stretchr/testify/assert"
	"google.golang.org/protobuf/types/known/structpb"
	"panoramix/configuration"
	"testing"
)

type validService struct {
}

func (s *validService) ValidMethod(p *structpb.Struct, owner string) error {
	return nil
}

type invalidservice1 struct {
}

func (s *invalidservice1) InvalidArgumentNumber(str string) error {
	return nil
}

type invalidservice2 struct {
}

func (s *invalidservice2) InvalidArgumentTypes(p string, owner string) error {
	return nil
}

type invalidservice3 struct {
}

func (s *invalidservice3) InvalidReturnValueNumber(p *structpb.Struct, owner string) (string, error) {
	return "", nil
}

type invalidservice4 struct {
}

func (s *invalidservice4) InvalidArgumentTypes(p *structpb.Struct, owner string) string {
	return ""
}

func TestRegisterServices(t *testing.T) {
	ctx := context.Background()
	dispatcher, err := RegisterServices(ctx, &configuration.Configuration{
		GoogleScopes: []string{},
	})

	assert.NoError(t, err)
	assert.NotNil(t, dispatcher)
}

func TestValidateMethod(t *testing.T) {
	testCases := []struct {
		name          string
		expectedError error
		service       interface{}
	}{
		{
			name:          "Valid service",
			expectedError: nil,
			service:       &validService{},
		},
		{
			name:          "Invalid method arguments' number",
			expectedError: ErrInvalidNumberOfArgumentsInMethod,
			service:       &invalidservice1{},
		},
		{
			name:          "Invalid method arguments' types",
			expectedError: ErrInvalidArgumentType,
			service:       &invalidservice2{},
		},
		{
			name:          "Invalid method return values number",
			expectedError: ErrInvalidNumberOfReturnValues,
			service:       &invalidservice3{},
		},
		{
			name:          "Invalid method return values types",
			expectedError: ErrInvalidReturnValueType,
			service:       &invalidservice4{},
		},
	}

	for _, tt := range testCases {
		t.Run(tt.name, func(t *testing.T) {
			err := validateMethodsSignatures(tt.service)
			assert.Equal(t, tt.expectedError, err)
		})
	}
}
