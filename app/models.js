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

  var lineSchema = new Schema({
    board_id: String,
    x1: Number,
    y1: Number,
    x2: Number,
    y2: Number
  });

  var boardSchema = new Schema({
    title: String
  });

  var Board  = db.model('board', boardSchema);
  var Postit = db.model('postit', postitSchema);
  var Line   = db.model('line', lineSchema);

  return {
    Board:  Board,
    Postit: Postit,
    Line:   Line
  };
};
