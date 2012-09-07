module.exports = function(db, Sequelize) {
  var Board = db.define("Board", {
    id : { type : Sequelize.INTEGER, autoIncrement: true }
  });

  var Postit = db.define("Postit", {
    id    : { type : Sequelize.INTEGER, autoIncrement: true },
    title : Sequelize.STRING,
    x     : Sequelize.INTEGER,
    y     : Sequelize.INTEGER,
    color : Sequelize.STRING
  });

  Board.hasMany(Postit);
  Postit.belongsTo(Board);

  Board.sync().error(function() {
    console.log(arguments);
  });

  Postit.sync().error(function() {
    console.log(arguments);
  });

  return {
    Board : Board,
    Postit : Postit
  };
};
