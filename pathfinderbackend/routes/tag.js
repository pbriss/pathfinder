var express = require('express');
var router = express.Router();
var models = require('../models');

/* GET suggest path. */
router.get('/all', function(req, res, next) {
  models.Tag.findAll().then(function(tags){
    // var result = [];
    // for(var i = 0; i < 5; i++){
    //   var place = places.splice(Math.floor(Math.random() * places.length), 1)[0];
    //   result.push(place.name);
    // }
    res.send(tags);
  });
});

module.exports = router;
