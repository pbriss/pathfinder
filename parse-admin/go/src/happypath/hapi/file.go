package hapi

import (
	"bytes"
	"encoding/json"
	"errors"
	"io/ioutil"
	"net/http"
)

type File struct {
	Name string `json:"name"`
	URL  string `json:"url"`
}

type FetchResult struct {
	ContentType string
	Body        []byte
}

// UploadFileToParse
func UploadFileToParse(data []byte, filename, contentType string) (*File, error) {
	req, err := http.NewRequest("POST", "https://api.parse.com/1/files/"+filename, bytes.NewReader(data))
	req.Header.Set("Content-Type", contentType)
	req.Header.Set("X-Parse-Application-Id", creds.ApplicationID)
	req.Header.Set("X-Parse-REST-API-Key", creds.RestAPIKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	ur := &File{}
	if err := json.NewDecoder(resp.Body).Decode(ur); err != nil {
		return ur, err
	}
	return ur, nil
}

// Lightweight HTTP Client to fetch the image
// Note: This will also pull webpages. @todo
// It is up to the user to use valid image urls.
func get(url string) (*FetchResult, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	ct := resp.Header.Get("Content-Type")

	if resp.StatusCode == 200 && len(body) > 512 {
		return &FetchResult{Body: body, ContentType: ct}, nil
	}

	return nil, errors.New("Couldn't fetch url " + url + ".")
}
