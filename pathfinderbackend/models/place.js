'use strict';
module.exports = function(sequelize, DataTypes) {
  var Place = sequelize.define('Place', {
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    averageRatingOverHundred: DataTypes.INTEGER
  }, {
    classMethods: {
      associate: function(models) {
        // associations can be defined here
      }
    }
  });
  return Place;
};
