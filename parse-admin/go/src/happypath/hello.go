package main

import (
	"fmt"
)

func main() {
	//	err := UpdatePlacesPicturesFromFlickr()
	//	if err != nil {
	//		fmt.Printf(err.Error())
	//	}
	err := FixPicsTypes()
	if err != nil {
		fmt.Printf(err.Error())
	}
}
