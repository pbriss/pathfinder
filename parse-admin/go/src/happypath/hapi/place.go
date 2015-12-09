package hapi

import (
	"log"
	"net/url"
)

type Place struct {
	ID              string   `json:"objectId,omitempty"`
	Name            string   `json:"name"`
	Tags            []string `json:"tags,omitempty"`
	Pictures        Pictures `json:"pictures,omitempty"`
	LocationPointer *Pointer `json:"location,omitempty"`
}

type Places []Place

// GetAllPlaces comment
func GetAllPlaces() (Places, error) {
	var res struct {
		Results Places `json:"results"`
	}

	cond := url.Values{}
	cond.Set("include", "pictures")
	cond.Set("limit", "1000")

	_, err := client.Get(&url.URL{
		Path:     "classes/Place",
		RawQuery: cond.Encode(),
	}, &res)
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

func (p *Place) PrependPicture(pic Picture) {
	p.Pictures = append(Pictures{pic}, p.Pictures...)
}

func (p *Place) Update() (*UpdateObjectResult, error) {
	log.Printf("Updated place %s\n", p.Name)
	temp := p.LocationPointer
	// pointers are updated differently. when it's included in this
	// update call, it causes api error at parse. so set it nil before.
	p.LocationPointer = nil
	var res UpdateObjectResult
	_, err := client.Put(&url.URL{
		Path: "classes/Place/" + p.ID,
	}, p, &res)
	p.LocationPointer = temp
	return &res, err
}
