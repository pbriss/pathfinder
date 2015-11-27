//var _     = require('lodash');

//var models = require('../models');
// var guideparser = require('../../guideparser.js');

import * as guideparser from '../lib/guideparser.js';
import * as yargs from 'yargs';

var argv = yargs
  .usage('Usage: $0 --guidesDir [dir] [options]')
  .demand(['guidesDir'])
  .help('h')
  .alias('h', 'help')
  .describe('parseLocationObjectId',
      'The Location object with which these places are going to be associated.')
  .describe('printOnly', 'Boolean to enable printing the result JSON only.')
  .boolean('printOnly')
  .argv;


guideparser.getFinalDataMap(argv.guidesDir)
  .then((data) => {
    console.log('here');
    console.log(data);
  })
  .catch(err => { console.log(err); });

//models.sequelize.sync({force: true}).then(function(){
//console.log("Models ready!");
//
//guideparser.getFinalDataMap(__dirname + '/../guides', (data) => {
//  var tagCreated = {};
//  _.map(data, (place) => {
//    models.Place.create({name: place.name});
//    place.tags
//      .filter((tag) => !tagCreated.hasOwnProperty(tag))
//      .forEach((tag) => {
//        tagCreated[tag] = true;
//        models.Tag.create({name: tag});
//      });
//  });
//});
//});
