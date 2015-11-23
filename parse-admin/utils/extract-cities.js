'use strict';

var cheerio = require('cheerio');
var fs = require('fs');
var request = require('request');
var async = require('async');
var Bing = require('node-bing-api')({accKey:"bdBsDaYGpn9Bfj7dXoTd3rUmMmK5tnCotL5YQXC/V8A"});

var getContents = function() {
  return fs.readFileSync('google-results/ca-cities.html', {encoding: 'utf-8'})
    .split(/\r/)
    .filter((s)=>s.length>0);
};

var download = function(uri, filename, callback){
  request.head(uri, function(err, res, body){
    console.log('content-type:', res.headers['content-type']);
    console.log('content-length:', res.headers['content-length']);

    request(uri).pipe(fs.createWriteStream(filename)).on('close', callback);
  });
};

var images = {};
var calls = [];

//getContents()
["Los Angeles"].forEach((name) => {
  calls.push((callback) => {
    Bing.images(name, {
      imageFilters: {
        size: 'width:1920',
        color: 'color'
      }
    }, function(err, res, body) {
      images[name] = [];
      var downloads = [];
      for(let i = 0; i < 5; i++){
        if(body.d.results[i]){
          let imgUrl = body.d.results[i].MediaUrl;
          images[name].push(imgUrl);
          downloads.push((downloadcallback) => {
            download(imgUrl, imgUrl.split('/').slice(-1)[0], ()=>downloadcallback(null));
          });
        }
      }
      async.parallel(downloads, (err, res) => {callback(null);});
    });
  });
});

async.parallel(calls, function(err, res) {
  if(err)console.log(err);
  console.log(images);
});


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
