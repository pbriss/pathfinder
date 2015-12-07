package flickr

import (
	"strconv"
)

type Picture struct {
	ID     string
	Title  string
	Width  int
	Height int
	URL    string
}

type Pictures []Picture

func GetPictures(name string, n int) (Pictures, error) {
	r, err := client.Search(map[string]string{
		"text":     name,
		"tags":     name,
		"sort":     "relevance",
		"media":    "photos",
		"per_page": strconv.Itoa(n),
		"extras":   "original_format,tags,url_o",
	})

	if err != nil {
		return nil, err
	}

	m := make(map[string]Picture)
	for _, p := range r.Photos {
		r, err := client.GetSizes(map[string]string{
			"photo_id": p.ID,
		})
		if err != nil {
			return nil, err
		}
		temp := r.Sizes[0]
		for _, s := range r.Sizes {
			if s.Label == "Original" ||
				s.Width >= temp.Width {
				temp = s
			}
		}
		if temp.Width >= 1920 &&
			temp.Height >= 1080 {
			m[p.ID] = Picture{
				ID:     p.ID,
				Title:  p.Title,
				Width:  temp.Width,
				Height: temp.Height,
				URL:    temp.SourceURL,
			}
		}
	}

	pp := Pictures{}
	for _, v := range m {
		pp = append(pp, v)
	}
	return pp, nil
}
