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

  var rulesSchema = new Schema({
    coords : {
      x : Number,
      y : Number
    }
  });

  var boardSchema = new Schema({
    title : String
  });

  var Board  = db.model('board', boardSchema);
  var Postit = db.model('postit', postitSchema);
  var Rules  = db.model('rules', rulesSchema);

  return {
    Board  : Board,
    Postit : Postit,
    Rules  : Rules
  };
};
