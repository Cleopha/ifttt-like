package scaleway

import "os"

// GetKeys returns the access and secret keys from a scaleway account using the credential API.
// TODO: Replace behaviour with credential API call.
func GetKeys() (string, string) {
	return os.Getenv("SCALEWAY_ACCESS_KEY"), os.Getenv("SCALEWAY_SECRET_KEY")
}
