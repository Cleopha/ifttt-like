package reaction

import "reflect"

type Reaction interface {
	Run(args []reflect.Value) error
}
