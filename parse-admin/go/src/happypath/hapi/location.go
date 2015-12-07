package hapi

import (
	"fmt"
	"net/url"
)

type Location struct {
	ID   string `json:"objectId,omitempty"`
	Name string `json:"name"`
	City string `json:"city,omitempty"`
}

type Locations []Location

var dat map[string]interface{}

// GetAllLocations
func GetAllLocations() {
	var locs struct {
		Results Locations `json:"results"`
	}
	_, err := client.Get(&url.URL{Path: "classes/Location"}, &locs)
	if err != nil {
		fmt.Printf(err.Error())
	} else {
		fmt.Printf("%+v\n", locs.Results)
	}
}
