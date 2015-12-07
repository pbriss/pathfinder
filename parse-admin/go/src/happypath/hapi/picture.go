package hapi

import (
//"fmt"
)

type Picture struct {
	OriginalTitle string `json:"title"`
	File          File   `json:"file"`
	Width         int    `json:"width,omitempty"`
	Height        int    `json:"height,omitempty"`
	IsAnimated    bool   `json:"isAnimated,omitempty"`
}

type Pictures []Picture

func UploadPictureToParseFromURL(url string) (*UploadResult, error) {
	r, err := get(url)
	if err != nil {
		return nil, err
	}
	return UploadFileToParse(r.Body, "test.jpg", r.ContentType)
}
