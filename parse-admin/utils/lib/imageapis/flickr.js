import * as Flickr from 'flickrapi';
import {logger, logerror} from '../common.js';

var flickrOptions = {
  api_key: '5106db59948a4bb58403289db61e6b27',
  secret: 'c5103dc3db8fab57'
};

var flickr;

Flickr.tokenOnly(flickrOptions, (err, api) => {
  flickr = api;
  flickr.photos.search({
    text: 'Marin Headlands'
  }, function(err, result) {
    for(let photo of result.photos.photo) {
      flickr.photos.getSizes({
        photo_id: photo.id,
      }, function(err, result) {
        debugger;
      });
    }
  });
});
