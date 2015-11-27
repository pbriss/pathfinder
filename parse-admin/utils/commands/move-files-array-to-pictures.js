'use strict';
var Parse = require('parse/node').Parse;
var async = require('async');
var fs = require('fs');

Parse.initialize('kvOdHosvHnOVJVhTrRjb67YxqQnrhDjkPkeGMJsj',
    'IKUaHBuYMvcqNOuaKbyZI1Q7zbjou1qLUDDbaVzq');

var Location = Parse.Object.extend('Location');

var getLocations = function(name) {
    var query = new Parse.Query(Location);
    query.include('pictures');
    return query.find();
};

var calls = [];

getLocations().then((res) => {
  for(let loc of res) {
    console.log(loc);
      console.log('fixing '+loc.get('name'));
      loc.set('pictures', loc.get('pictures_fixed'));
      loc.save();
  }
});


async.series(calls);
