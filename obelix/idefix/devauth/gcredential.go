package devauth

import (
	"context"
	"fmt"
	"golang.org/x/oauth2"
	"net/url"
)

// GetAccessToken retrieves the access token needed to perform Google Authenticated requests
// TODO: Use the credential API to get the token
func GetAccessToken(ctx context.Context, conf *oauth2.Config) (*oauth2.Token, error) {
	accessURL := conf.AuthCodeURL("state")
	fmt.Printf("Visit the URL for the auth dialog: %v\n", accessURL)

	rawCode := ""
	_, err := fmt.Scanf("%s", &rawCode)

	if err != nil {
		return nil, fmt.Errorf("failed to read code: %w", err)
	}

	code, err := url.QueryUnescape(rawCode)
	if err != nil {
		return nil, fmt.Errorf("failed to parse code: %w", err)
	}

	token, err := conf.Exchange(ctx, code)
	if err != nil {
		return nil, fmt.Errorf("failed to exchange authoziation code for an access token: %w", err)
	}

	return token, nil
}
