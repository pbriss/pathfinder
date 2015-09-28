var fs        = require('fs');
var cheerio   = require('cheerio');
var _         = require('lodash');

var guidesDir = __dirname + '/guides';

//TODO(ftufek): removed tag parsing for now because of bugs, write a more modular parser
var parseGuide = function (htmlString){
  var $ = cheerio.load(htmlString);
  var titles = $('.modules-triplist-detail-item-pane .heading').contents();
  var titlesArr = [];
  for(var i = 0; i < titles.length; i++){
    titlesArr.push(titles[i].data);
  }
  return titlesArr;
};

var res = fs
  .readdirSync(guidesDir) //TODO(ftufek): switch to async file reading
  .filter(file => file.slice(-5) == '.html')
  .map(file => guidesDir + '/' + file)
  .map(file => parseGuide(fs.readFileSync(file))) //TODO(ftufek): switch to async file reading
  .reduce((globalTitlesArr, titlesArr) => titlesArr.concat(globalTitlesArr));

module.exports = {
  //TODO(ftufek): write better/flexible exported functions
  getTitles: function(){
    return _.unique(res);
  }
};
