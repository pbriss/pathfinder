package hapi

import (
	"log"
	"net/url"
)

type Location struct {
	ID       string   `json:"objectId,omitempty"`
	Name     string   `json:"name"`
	City     string   `json:"city,omitempty"`
	Pictures Pictures `json:"pictures,omitempty"`
}

type Locations []Location

var dat map[string]interface{}

// GetAllLocations
func GetAllLocations() (Locations, error) {
	var res struct {
		Results Locations `json:"results"`
	}

	cond := url.Values{}
	cond.Set("include", "pictures")
	cond.Set("limit", "1000")

	_, err := client.Get(&url.URL{
		Path:     "classes/Location",
		RawQuery: cond.Encode(),
	}, &res)
	return res.Results, err
}

func (l *Location) Update() (*UpdateObjectResult, error) {
	log.Printf("Updated location %s\n", l.Name)
	var res UpdateObjectResult
	_, err := client.Put(&url.URL{
		Path: "classes/Location/" + l.ID,
	}, l, &res)
	return &res, err
}

func (p *Location) PrependPicture(pic Picture) {
	p.Pictures = append(Pictures{pic}, p.Pictures...)
}
