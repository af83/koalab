var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

module.exports = function(db) {
  var postitSchema = new Schema({
    title  : String,
    coords : {
      x : Number,
      y : Number
    },
    size   : {
      w : Number,
      h : Number
    },
    color    : String,
    angle    : Number,
    board_id : String
  });

  var linesSchema = new Schema({
    coords : {
      x1 : Number,
      y1 : Number,
      x2 : Number,
      y2 : Number
    }
  });

  var boardSchema = new Schema({
    title : String,
    lines : [linesSchema]
  });

  var Board  = db.model('board', boardSchema);
  var Postit = db.model('postit', postitSchema);
  var Lines  = db.model('lines', linesSchema);

  return {
    Board  : Board,
    Postit : Postit,
    Lines  : Lines
  };
};
