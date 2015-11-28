import * as bunyan from 'bunyan';

export var logger = bunyan.createLogger({
  name: 'parseadmin',
  src: true,
  streams: [
    {
      level: 'info',
      stream: process.stdout
    },
    {
      level: 'error',
      path: '/var/tmp/parseadmin-error.log'
    }
  ]
});

export function logerror(err) {
  logger.error(err);
};

export var logparse = {
  success: function (obj) {
    logger.info(obj.id, 'Saved parse object.');
  },
  error: function (obj, error) {
    logger.info(obj.get('name'), 'Couldn\'t save parse object.', error);
  }
};
