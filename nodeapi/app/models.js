var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

module.exports = function(db) {
  var postitSchema = new Schema({
    title  : String,
    coords : [],
    size   : [],
    color  : String,
    angle  : Number
  });

  var boardSchema = new Schema({
    postits : [postitSchema]
  });

  var rulesSchema = new Schema({
    coords : []
  });

  return {
    board  : mongoose.model('Board', boardSchema),
    postit : mongoose.model('Postit', postitSchema),
    rules  : mongoose.model('Rules', rulesSchema)
  };
};
