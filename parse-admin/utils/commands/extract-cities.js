'use strict';

var cheerio = require('cheerio');
var fs = require('fs');
var request = require('request');
var async = require('async');
var Bing = require('node-bing-api')({accKey:"bdBsDaYGpn9Bfj7dXoTd3rUmMmK5tnCotL5YQXC/V8A"});

var getContents = function() {
  return fs.readFileSync('../google-results/ca-cities.html', {encoding: 'utf-8'})
    .split(/\r/)
    .filter((s)=>s.length>0);
};

var download = function(uri, filename, callback){
  request.head(uri, function(err, res, body){
    if(err){console.log(err); callback(false); return;}
    console.log('content-type:', res.headers['content-type']);
    console.log('content-length:', res.headers['content-length']);

    request(uri).pipe(fs.createWriteStream(filename)).on('close', callback);
  });
};

var images = {};
var calls = [];
var errors = [];

getContents()
  .forEach((name) => {
  calls.push((callback) => {
    Bing.images(name, {
      imageFilters: {
        size: 'width:1920',
        color: 'color'
      }
    }, function(err, res, body) {
      if(err){console.log(err);
        console.log(name);
        errors.push(name);
        return;}
      images[name] = [];
      var downloads = [];
      for(let i = 0; i < 10; i++){
        if(body.d.results[i]){
          let imgUrl = body.d.results[i].MediaUrl;
          let imgName = imgUrl.split('/').slice(-1)[0]
          downloads.push((downloadcallback) => {
            download(imgUrl, imgName, (bool) => {
              if(bool == false){downloadcallback(null);return;}
              images[name].push(imgName);
              fs.writeFileSync('images.json', JSON.stringify(images));
              downloadcallback(null);
            });
          });
        }
      }
      downloads.push(()=>callback());
      async.series(downloads);
    });
  });
});

async.series(calls);


/*
Bing.images("Berkeley, CA, USA", {
  imageFilters: {
    size: 'width:1920',
    color: 'color'
  }
}, function(err, res, body){
  console.log(body.d.results[0]);
});
*/
