package main

import (
	"fmt"
	"happypath/flickr"
	"happypath/hapi"
	"log"
)

func UpdatePlacesPicturesFromFlickr() error {
	res, err := hapi.GetAllPlacesWithoutPics()
	if err != nil {
		fmt.Printf(err.Error())
	}

	for _, p := range res {
		log.Printf("Getting pictures for %s.\n", p.Name)
		pics, err := flickr.GetPictures(p.Name, 15)
		if err != nil {
			return err
		}
		log.Printf("Got %d pictures for %s, uploading to Parse.\n", len(pics), p.Name)
		for _, pic := range pics {
			hp, err := hapi.UploadPictureFromFlickr(pic)
			if err != nil {
				return err
			}
			p.PrependPicture(*hp)
		}
		log.Printf("Updating Parse object for %s with the pictures: %+v.\n", p.Name, p.Pictures)
		if _, err := (&p).Update(); err != nil {
			return err
		}
	}

	return nil
}

func FixPicsTypes() error {
	res, err := hapi.GetAllPlaces()
	if err != nil {
		return err
	}

	for _, pl := range res {
		final := hapi.Pictures{}
		for _, p := range pl.Pictures {
			if p.File.URL != "" {
				p.File.Type = "File"
				final = append(final, p)
			}
		}
		pl.Pictures = final
		pl.Update()
	}
	return nil
}
