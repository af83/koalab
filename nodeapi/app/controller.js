var express = require('express'),
    errors  = require('./errors');

function loader(Model, id) {
  return function(req, res, next) {
    var param = req.params[id];
    if (!('string' === typeof param && 24 === param.length)) {
      return next(new errors.BadRequest());
    }
    Model.findById(param, function(err, model) {
      if (err) return next(err);
      if (!model) return next(new errors.NotFound('wrong id'));
      req[Model.modelName] = model;
      next();
    });
  };
}

module.exports = function(app, db) {
  var models = require('./models')(db),

      Board  = models.Board,
      Postit = models.Postit,
      Lines  = models.Lines;

  app.get('/', function(req, res) {
    res.render('index');
  });

  app.get('/boards', function(req, res, next) {
    var boards = Board.find({}, function(err, boards) {
      if(err) return next(err);
      res.send(boards);
    });
  });

  // Create Board
  app.post('/boards', function(req, res, next) {
    var board = new Board(req.body);
    board.save(function(err) {
      if (err) return next(err);
      res.send(201, board);
    });
  });

  // Get Board
  app.get('/boards/:bid', loader(Board, 'bid'), function(req, res) {
    res.send(req.board);
  });

  // Update Board
  app.put('/boards/:bid', function(req, res, next) {
    Board.findByIdAndUpdate(req.params.bid, req.body, function(err) {
      if (err) return next(err);
      res.send(204);
    });
  });

  // Create Postit
  app.post('/boards/:bid/postits', function(req, res, next) {
    req.body.board_id = req.params.bid;
    var postit = new Postit(req.body);
    postit.save(function(err) {
      if (err) return next(err);
      res.send(201, postit);
    });
  });

  // Get postits
  app.get('/boards/:bid/postits', function(req, res, next) {
    var bid = req.params.bid;
    Postit.find({ board_id : bid }, function(err, postits) {
      if (err) return next(new Error());
      res.send(postits);
    });
  });

  // Get postit
  app.get('/boards/:bid/postits/:pid', loader(Postit, 'pid'), function(req, res) {
    res.send(req.postit);
  });

  // Update postit
  app.put('/boards/:bid/postits/:pid', function(req, res, next) {
    Postit.findByIdAndUpdate(req.params.pid, req.body, function(err) {
      if (err) return next(err);
      res.send(204);
    });
  });
};
