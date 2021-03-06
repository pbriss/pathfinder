var fs        = require('fs');
var async     = require('async');
var Q         = require('q');
var Xray      = require('x-ray');
var _         = require('lodash');

var parseGuide = function (html, parserSpec){
  parserSpec = parserSpec || {
    placeScope: '.entry',
    placeName: '.heading',
    placeTags: '.tag'
  };
  let x = Xray();
  let t = x(html, parserSpec.placeScope, [{
    name: parserSpec.placeName,
    tags: [parserSpec.placeTags]
  }]);
  return function(callback){ t(callback); };
};

var mapAllGuides = function (guidesDir) {
  let deferred = Q.defer();
  var parserSpecFilename = guidesDir + '/parserspec.json';
  var parserSpec = fs.existsSync(parserSpecFilename) ?
                      JSON.parse(fs.readFileSync(parserSpecFilename)) : null;
  let futures = fs
    .readdirSync(guidesDir)
    .filter(file => file.slice(-5) == '.html')
    .map(file => guidesDir + '/' + file)
    .map(file => parseGuide(fs.readFileSync(file), parserSpec));
  async.parallel(futures, (err, results) => {
    if(err){
      deferred.reject(new Error(err));
    }else{
      deferred.resolve(results);
    }
  });
  return deferred.promise;
};

var reduce = function(allGuidesData) {
  return allGuidesData.reduce((prev, curr) => {
    for(let place of curr){
      if(prev.hasOwnProperty(place.name)){
        var prevPlace = prev[place.name];
        prevPlace.tags = _.unique(prevPlace.tags.concat(place.tags));
      }else{
        prev[place.name] = place;
      }
    }
    return prev;
  }, {});
};

module.exports = {
  getFinalDataMap: function(guidesDir, callback){
    guidesDir = guidesDir || __dirname + '/guides';
    return mapAllGuides(guidesDir)
              .then((duplicates) => reduce(duplicates))
              .then(callback);
  }
};
