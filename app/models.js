var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

module.exports = function(db) {
  var postitSchema = new Schema({
    board_id: String,
    title:    String,
    coords: {
      x: Number,
      y: Number
    },
    size: {
      w: Number,
      h: Number
    },
    color: String,
    angle: Number,
    updated_at: Date
  });

  var linesSchema = new Schema({
    x1: Number,
    y1: Number,
    x2: Number,
    y2: Number
  });

  var boardSchema = new Schema({
    title: String,
    lines: [linesSchema]
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
