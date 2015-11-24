'use strict';
var Parse = require('parse/node').Parse;
var async = require('async');
var fs = require('fs');

Parse.initialize('kvOdHosvHnOVJVhTrRjb67YxqQnrhDjkPkeGMJsj',
    'IKUaHBuYMvcqNOuaKbyZI1Q7zbjou1qLUDDbaVzq');

var images = JSON.parse(fs.readFileSync('images/images.json'));
var Location = Parse.Object.extend('Location');

var getLocation = function(name) {
    var query = new Parse.Query(Location);
    query.equalTo('name', name);
    query.include('pictures');
    return query.first();
};

var readBase64 = function(name) {
  var bitmap = fs.readFileSync(name);
  return new Buffer(bitmap).toString('base64');
};

var calls = [];

for(let loc in images) {
  if(images.hasOwnProperty(loc)){
    let urls = images[loc];
    for(let url of urls){
      calls.push((callback) => {
        console.log('location '+loc);
        if(url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg')){
          let base64 = readBase64('images/'+url);
          let file = new Parse.File('a.'+url.split('.').slice(-1)[0], {base64: base64});
          file.save().then(()=>{
            let location = getLocation(loc).then((res) => {
              let locPics = res.get('pictures');
              if(locPics == undefined || locPics == null){
                res.set('pictures', []);
              }
              res.get('pictures').push(file);
              res.save().then(()=>{
                urls.splice(urls.indexOf(url), 1);
                fs.writeFileSync('images/images.json', JSON.stringify(images));
                callback();
              });
            });
          });
        }else{
          callback();
        }
      });
    }
  }
}

async.series(calls);
