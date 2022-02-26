package services

import (
	"context"
	"errors"
	"fmt"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"google.golang.org/protobuf/types/known/structpb"
	"panoramix/configuration"
	"panoramix/services/google"
	"reflect"
)

var (
	ErrInvalidNumberOfArgumentsInMethod = errors.New("one of the registered methods has an invalid number of args")
	ErrInvalidNumberOfReturnValues      = errors.New(
		"one of the registered methods has an invalid number return values")
	ErrInvalidArgumentType    = errors.New("one of the method's argument does not have a valid type")
	ErrInvalidReturnValueType = errors.New("one of the method's returned value does not have a valid type")
)

type expectedSignature = func(p *structpb.Struct, owner string) error

func validateMethodsSignatures(service interface{}) error {
	st := reflect.TypeOf(service)
	if st.Kind() == reflect.Struct || st.Kind() != reflect.Ptr {
		return dispatcher.ErrInvalidServiceType
	}

	//nolint:unconvert
	expected := expectedSignature(func(p *structpb.Struct, owner string) error {
		return nil
	})

	for i := 0; i < st.NumMethod(); i++ {
		// We only care about exported methods.
		if !(st.Method(i).PkgPath == "") {
			continue
		}

		// Verify method arguments.
		if st.Method(i).Type.NumIn()-1 != reflect.TypeOf(expected).NumIn() {
			return ErrInvalidNumberOfArgumentsInMethod
		}

		for j := 1; j < reflect.TypeOf(expected).NumIn(); j++ {
			if !st.Method(i).Type.In(j).AssignableTo(reflect.TypeOf(expected).In(j - 1)) {
				return ErrInvalidArgumentType
			}
		}

		// Verify method return values.
		if st.Method(i).Type.NumOut() != reflect.TypeOf(expected).NumOut() {
			return ErrInvalidNumberOfReturnValues
		}

		for j := 0; j < reflect.TypeOf(expected).NumOut(); j++ {
			if !st.Method(i).Type.Out(j).AssignableTo(reflect.TypeOf(expected).Out(j)) {
				return ErrInvalidReturnValueType
			}
		}
	}

	return nil
}

func RegisterServices(ctx context.Context, conf *configuration.Configuration) (*dispatcher.Dispatcher, error) {
	d := dispatcher.New()

	googleClient := google.New(ctx, conf.GoogleScopes)

	// Validate google methods signatures
	if err := validateMethodsSignatures(googleClient); err != nil {
		return nil, err
	}

	if err := d.Register("google", googleClient); err != nil {
		return nil, fmt.Errorf("failed to register Google service: %w", err)
	}

	return d, nil
}
