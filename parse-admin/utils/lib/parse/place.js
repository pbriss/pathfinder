import {Parse} from 'parse/node';

export var Place = Parse.Object.extend('Place');

export function getPlacesMissingPictures() {
  return new Parse.Query(Place)
    .doesNotExist('pictures')
    .find();
}
