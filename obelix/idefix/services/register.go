package services

import (
	"context"
	"errors"
	"fmt"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"go.uber.org/zap"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"idefix/services/github"
	"idefix/services/google"
	"reflect"
)

var (
	ErrInvalidNumberOfArgumentsInMethod = errors.New("one of the registered methods has an invalid number of args")
	ErrInvalidNumberOfReturnValues      = errors.New(
		"one of the registered methods has an invalid number return values")
	ErrInvalidArgumentType    = errors.New("one of the method's argument does not have a valid type")
	ErrInvalidReturnValueType = errors.New("one of the method's returned value does not have a valid type")
)

type expectedSignature = func(taskID string, prm *structpb.Struct, owner string) error

func validateMethodsSignatures(service interface{}) error {
	st := reflect.TypeOf(service)
	if st.Kind() == reflect.Struct || st.Kind() != reflect.Ptr {
		return dispatcher.ErrInvalidServiceType
	}

	//nolint:unconvert
	expected := expectedSignature(func(taskID string, prm *structpb.Struct, owner string) error {
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

func RegisterServices(ctx context.Context) (*dispatcher.Dispatcher, error) {
	d := dispatcher.New()
	kp, err := producer.New()

	if err != nil {
		return nil, fmt.Errorf("failed to create task producer: %w", err)
	}

	rc := redis.NewClient(ctx)

	githubClient := github.NewClient(ctx, &operator.IdefixOperator{
		RC: rc,
		KP: kp,
	})

	googleClient := &google.Client{
		Requester: nil,
		Scope: []string{
			"https://www.googleapis.com/auth/bigquery",
			"https://www.googleapis.com/auth/blogger",
			"https://www.googleapis.com/auth/calendar",
		},
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
	}

	if err := validateMethodsSignatures(googleClient); err != nil {
		return nil, err
	}

	if err := validateMethodsSignatures(githubClient); err != nil {
		return nil, err
	}

	if err = d.Register("github", githubClient); err != nil {
		return nil, fmt.Errorf("failed to register Github services: %w", err)
	}

	if err = d.Register("google", googleClient); err != nil {
		return nil, fmt.Errorf("failed to register Google services: %w", err)
	}

	zap.S().Info("Services are now loaded into idefix")

	return d, nil
}
