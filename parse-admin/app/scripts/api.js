(function(document, Parse) {
  'use strict';

  var Location = Parse.Object.extend('Location');

  let singleton;

  class ParseApi {
    constructor() {
      if(singleton) return singleton;

      if (!singleton) {
        singleton = this;
      }
      this.init_();
      return singleton;
    }

    initParseRoles_() {
      //Check Administrator role first
      var query = new Parse.Query(Parse.Role);
      query.equalTo('name', 'Administrator');
      query.first()
      .then(function(res) {
//        if (res && Parse.User.current()) {
//          console.log('Adding current user to Administrator role.');
//          res.getUsers().add(Parse.User.current());
//          res.save().then((s)=>{console.log(s)},(e)=>{console.log(e);});
//        }
        if (res === undefined) {
          var roleACL = new Parse.ACL();
          roleACL.setPublicReadAccess(true);
          roleACL.setPublicWriteAccess(false);

          var AdministratorRole = new Parse.Role(
            'Administrator', roleACL);
          AdministratorRole.save().then(
          function(res) {console.log(res);},
          function(err) {console.log(err);});
        } // add else condition
      }, function(err) {
        console.log(err);
      });
    }

    init_() {
      Parse.initialize('kvOdHosvHnOVJVhTrRjb67YxqQnrhDjkPkeGMJsj',
        'IKUaHBuYMvcqNOuaKbyZI1Q7zbjou1qLUDDbaVzq');
      this.initParseRoles_();
    }

    addPictureToLocation(objectId, name, file, callback) {
      var parseFile = new Parse.File(name, file);
      console.log(name);
      parseFile.save().then((res) => {
        console.log(res);
        this.getLocation(objectId).then((loc) => {
          loc.add('pictures', parseFile);
          loc.save().then(
            (res) => {console.log(res)},
            (error) => {console.log(error)});
        })
      },
      (error) => {console.log(error);});
    }

    getLocationById(objectId) {
      return new Parse.Query(Location).get(objectId);
    }

    getLocations() {
      var query = new Parse.Query(Location);
      query.include('pictures');
      return query.find();
    }

    getLocation(name) {
      var query = new Parse.Query(Location);
      query.equalTo('name', name);
      query.include('pictures');
      return query.first();
    }

    insertCitiesIfInexistent(cities, state, country) {
      for(let city of cities){
        if(city.length > 0){
          this.getLocation(city).then((res)=>{
                if(res) return;
                // the city didn't exist so insert it
                var location = new Location();
                location.set('name', city);
                location.set('city', city);
                location.set('state', state);
                location.set('country', country);
                location.save().then(
                  (success) => {console.log('Successfully created '+city)},
                  (error) => {console.log('Error creating '+city+','+error.message);});
              });
        }
      }
    }

    fileUrlToBase64_(url, callback) {
      var xhr = new XMLHttpRequest();
      xhr.responseType = 'blob';
      xhr.onload = function() {
        var reader  = new FileReader();
        reader.onloadend = function () {
          callback(reader.result);
        }
        reader.readAsDataURL(xhr.response);
      };
      xhr.open('GET', url);
      xhr.send();
    }

    uploadLocationPictures(dataJson, urlPrefix) {
      for(let loc in dataJson){
        if(dataJson.hasOwnProperty(loc)) {
          let val = dataJson[loc];
          for(let imgUrl in val){
            this.fileUrlToBase64_(imgUrl, (res) => console.log(res));
          }
        }
      }
    }
  }

  window.Api = ParseApi;
})(document, window.Parse);
