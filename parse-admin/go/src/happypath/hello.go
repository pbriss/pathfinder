package main

import (
	"fmt"
	//	"happypath/flickr"
	"happypath/hapi"
)

func main() {
	res, err := hapi.GetAllPlacesWithoutPics()
	if err != nil {
		fmt.Printf(err.Error())
	} else {
		for _, p := range res {
			p.Test = "a"
			if _, err := (&p).Update(); err != nil {
				fmt.Printf(err.Error())
			}
		}
	}
}
