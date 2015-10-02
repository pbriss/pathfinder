var _     = require('lodash');

var models = require('../models');
var guideparser = require('../guideparser.js');

models.sequelize.sync({force: true}).then(function(){
console.log("Models ready!");

guideparser.getFinalDataMap(__dirname + '/../guides', (data) => {
  var tagCreated = {};
  _.map(data, (place) => {
    models.Place.create({name: place.name});
    place.tags
      .filter((tag) => !tagCreated.hasOwnProperty(tag))
      .forEach((tag) => {
        tagCreated[tag] = true;
        models.Tag.create({name: tag});
      });
  });
});
});
