package hapi

import (
	"net/url"
)

type Place struct {
	ID              string   `json:"objectId,omitempty"`
	Name            string   `json:"name"`
	Tags            []string `json:"tags,omitempty"`
	Pictures        Pictures `json:"pictures,omitempty"`
	LocationPointer Pointer  `json:"location,omitempty"`
	Test            string   `json:"cooltest,omitempty"`
}

type Places []Place

// GetAllPlaces comment
func GetAllPlaces() (Places, error) {
	var res struct {
		Results Places `json:"results"`
	}
	_, err := client.Get(&url.URL{Path: "classes/Place"}, &res)
	return res.Results, err
}

func GetAllPlacesWithoutPics() (Places, error) {
	var res struct {
		Results Places `json:"results"`
	}

	cond := url.Values{}
	cond.Set("where", `{"pictures":{"$exists":false}}`)
	cond.Set("include", "pictures")

	_, err := client.Get(&url.URL{
		Path:     "classes/Place",
		RawQuery: cond.Encode(),
	}, &res)
	return res.Results, err
}

func (p *Place) Update() (*UpdateObjectResult, error) {
	var res UpdateObjectResult
	_, err := client.Put(&url.URL{
		Path: "classes/Place/" + p.ID,
	}, p, &res)
	return &res, err
}
