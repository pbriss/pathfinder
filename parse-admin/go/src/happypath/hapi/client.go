package hapi

import (
	"github.com/facebookgo/parse"
)

var creds = parse.RestAPIKey{
	ApplicationID: "kvOdHosvHnOVJVhTrRjb67YxqQnrhDjkPkeGMJsj",
	RestAPIKey:    "jSU1X6dE3So8ZA3FsMecnCXgzu6EOceFXGsALVcE",
}

var client = &parse.Client{
	Credentials: creds,
}

type UpdateObjectResult struct {
	UpdatedAt string `json:"updatedAt"`
}
