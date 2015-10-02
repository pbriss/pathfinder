var chai = require('chai');
var parser = require('../guideparser.js');

var testGuidesDir = __dirname + '/testguides';

chai.should();

describe('guideparser', () => {
  var parsedGuides;

  before((done) => {
    parser.getFinalDataMap(testGuidesDir, (data) => {
      parsedGuides = data;
      done();
    });
  });

  it('should parse names correctly', () => {
    Object.keys(parsedGuides).should.have.length(3);
    parsedGuides.should.have.CoolName;
    parsedGuides.should.have.NameTwo;
    parsedGuides.should.have.NameThree;
  });

  it('should parse tags correctly', () => {
    parsedGuides.CoolName.tags.should.eql([ 'Tag1', 'Tag2' ]);
    parsedGuides.NameTwo.tags.should.eql([ 'Tag3', 'Tag1', 'Tag6' ]);
    parsedGuides.NameThree.tags.should.eql([]);
  });
});
