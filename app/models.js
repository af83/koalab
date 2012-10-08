var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

module.exports = function(db) {
  var boardSchema = new Schema({
    title: String
  });

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

  postitSchema.index({ board_id: 1 });
  lineSchema.index({ board_id: 1 });

  return {
    Board:  db.model('board', boardSchema),
    Postit: db.model('postit', postitSchema),
    Line:   db.model('line', lineSchema)
  };
};
