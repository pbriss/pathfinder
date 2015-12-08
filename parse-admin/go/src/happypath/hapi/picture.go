package hapi

import (
	"happypath/flickr"
	"strings"
)

type Picture struct {
	OriginalTitle string `json:"title"`
	OriginalID    string `json:"originalID"`
	Source        string `json:"source"`
	File          *File  `json:"file"`
	Width         int    `json:"width,omitempty"`
	Height        int    `json:"height,omitempty"`
	IsAnimated    bool   `json:"isAnimated,omitempty"`
}

type Pictures []Picture

func UploadPictureToParseFromURL(url string) (*File, error) {
	s := strings.Split(url, "/")
	r, err := get(url)
	if err != nil {
		return nil, err
	}
	return UploadFileToParse(r.Body, s[len(s)-1], r.ContentType)
}

func UploadPictureFromFlickr(p flickr.Picture) (*Picture, error) {
	f, err := UploadPictureToParseFromURL(p.URL)
	if err != nil {
		return nil, err
	}

	pic := &Picture{
		OriginalTitle: p.Title,
		OriginalID:    p.ID,
		Source:        "flickr",
		File:          f,
		Width:         p.Width,
		Height:        p.Height,
		IsAnimated:    false,
	}
	return pic, nil
}
