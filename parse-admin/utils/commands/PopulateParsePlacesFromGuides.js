import * as guideparser from '../lib/guideparser.js';
import * as yargs from 'yargs';
import {logger, logerror, logparse} from '../lib/common';
import {Location, getLocationWithId} from '../lib/parse/location';
import {Place} from '../lib/parse/place';
import * as async from 'async';
import {Parse} from 'parse/node';

Parse.initialize('kvOdHosvHnOVJVhTrRjb67YxqQnrhDjkPkeGMJsj',
    'IKUaHBuYMvcqNOuaKbyZI1Q7zbjou1qLUDDbaVzq');

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
    if (argv.printOnly) {
      logger.info(data, 'printOnly option was passed.');
    } else if (argv.parseLocationObjectId) {
      logger.info({locationObjectId: argv.parseLocationObjectId},
        'Adding %s places to the given location object.', data.length);

      getLocationWithId(argv.parseLocationObjectId).then((location) => {
        for(let key in data) {
          if (data.hasOwnProperty(key)) {
            let place = data[key];
            place.location = location;
            let parseObj = new Place(place);
            parseObj.save(null, logparse);
          }
        }
      });

    }
  })
  .catch(logerror);
