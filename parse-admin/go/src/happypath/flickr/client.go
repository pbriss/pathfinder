package flickr

import (
	"github.com/manki/flickgo"
	"net/http"
)

var httpClient = &http.Client{}

var client = flickgo.New(
	"5106db59948a4bb58403289db61e6b27",
	"c5103dc3db8fab57",
	httpClient,
)
