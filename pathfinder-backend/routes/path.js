var express = require('express');
var router = express.Router();
var models = require('../models');

/* GET suggest path. */
router.get('/suggest', function(req, res, next) {
  //TODO(ftufek): very inefficient, all places are always loaded from DB,
  //and randomly selected on the server, find better ways
  models.Place.findAll().then(function(places){
    var result = [];
    for(var i = 0; i < 5; i++){
      var place = places.splice(Math.floor(Math.random() * places.length), 1)[0];
      result.push(place.name);
    }
    res.send(result);
  });
});

module.exports = router;
