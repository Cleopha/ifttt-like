package trigger

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func ReadBody(res *http.Response) ([]byte, error) {
	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		return nil, fmt.Errorf("failed to read body: %w", err)
	}
	return body, nil
}
