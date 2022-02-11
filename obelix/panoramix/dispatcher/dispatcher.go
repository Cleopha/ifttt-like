package dispatcher

import (
	"context"
	"fmt"
	"panoramix/configuration"
	"panoramix/services/google"
	"reflect"
)

var (
	ErrInvalidNumberOfArguments = fmt.Errorf("invalid number of arguments provided")
	ErrInvalidArgumentType      = fmt.Errorf("invalid argument's type")
)

// funcMeta represents a struct method.
// It contains the method and the required number of arguments for this method.
type funcMeta struct {
	fv        reflect.Value
	numArgs   int
	argsTypes []reflect.Type
}

// funcData represents an association between a service and its methods.
// e.g.: Google and CreateNewDocument.
type funcData struct {
	service reflect.Value
	methods map[string]funcMeta
}

// Dispatcher wraps the service maps.
type Dispatcher struct {
	serviceMap map[string]*funcData
}

// New creates a new dispatcher which creates,
// verifies and registers the services and its corresponding methods.
func New(ctx context.Context, conf *configuration.Configuration) (*Dispatcher, error) {
	d := Dispatcher{
		serviceMap: make(map[string]*funcData),
	}

	// Creates the Google client
	googleClient, err := google.New(ctx, conf.GoogleScopes)
	if err != nil {
		return nil, fmt.Errorf("failed to create Google client: %w", err)
	}

	// Registers the Google client
	err = d.register("google", googleClient)
	if err != nil {
		return nil, fmt.Errorf("failed to register Google client: %w", err)
	}

	return &d, nil
}

// register adds a service and its corresponding methods in the dispatcher.
// It saves each method metadata in the process for further sanity checks.
func (d *Dispatcher) register(name string, service interface{}) error {
	st := reflect.TypeOf(service)
	methods := make(map[string]funcMeta)

	if st.Kind() == reflect.Struct {
		return fmt.Errorf("service '%s' must be a pointer to struct", service)
	}

	// Saves the service's methods
	for i := 0; i < st.NumMethod(); i++ {
		// Saves the argument's types
		argsTypes := []reflect.Type{}
		for j := 0; j < st.Method(i).Func.Type().NumIn(); j++ {
			argsTypes = append(argsTypes, st.Method(i).Func.Type().In(j))
		}

		methods[st.Method(i).Name] = funcMeta{
			fv:        st.Method(i).Func,
			numArgs:   st.Method(i).Func.Type().NumIn(),
			argsTypes: argsTypes,
		}
	}

	// Saves the service along with its methods in the dispatcher
	fd := &funcData{}
	fd.service = reflect.ValueOf(service)
	fd.methods = methods

	d.serviceMap[name] = fd

	return nil
}

// Run calls the given method which belongs to the given service, providing necessary arguments in the process.
func (d *Dispatcher) Run(service, method string, args ...interface{}) error {
	// Provide the first argument - the service object
	inArgs := make([]reflect.Value, 1+len(args))
	inArgs[0] = d.serviceMap[service].service

	// Provide the arguments for the method
	for i, arg := range args {
		inArgs[i+1] = reflect.ValueOf(arg)
	}

	// Checks the arguments count
	if len(inArgs) != d.serviceMap[service].methods[method].numArgs {
		return ErrInvalidNumberOfArguments
	}

	// Check the arguments types
	for i, arg := range args {
		if reflect.TypeOf(arg) != d.serviceMap[service].methods[method].argsTypes[i+1] {
			return ErrInvalidArgumentType
		}
	}

	// Call the method
	d.serviceMap[service].methods[method].fv.Call(inArgs)
	return nil
}
