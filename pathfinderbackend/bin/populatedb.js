var models = require('../models');
var guideparser = require('../guideparser.js');

models.sequelize.sync().then(function(){
console.log("Models ready!");
guideparser.getTitles()
  .forEach(title => models.Place.create({name: title}));
});
