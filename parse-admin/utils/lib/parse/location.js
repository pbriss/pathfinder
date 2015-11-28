import {Parse} from 'parse/node';

export var Location = Parse.Object.extend('Location');

export function getLocationWithId(objId) {
  return new Parse.Query(Location).get(objId);
};
