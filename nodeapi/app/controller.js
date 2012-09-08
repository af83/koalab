var express = require('express');

function loader(Model, id) {
  return function(req, res, next) {
    Model.findById(req.params[id], function(err, model) {
      if (err) return next(err);
      if (!model) return next(new Error('wrong id'));
      req[Model.modelName] = model;
      next();
    });
  };
}

module.exports = function(app, db) {
  var models = require('./models')(db),

      Board  = models.Board,
      Postit = models.Postit,
      Rules  = models.Rules;

  app.get('/', function(req, res) {
    res.render('index');
  });

  app.get('/boards', function(req, res) {
    var boards = Board.find({}, function(err, boards) {
      if(err) return res.send(err);
      res.send(boards);
    });
  });

  // Create Board
  app.post('/boards', function(req, res) {
    var board = new Board(req.body);
    board.save(function(err) {
      if(err) return res.send(err);
      res.send(201, board);
    });
  });

  // Get Board
  app.get('/boards/:bid', loader(Board, 'bid'), function(req, res) {
    res.send(req.board);
  });

  // Update Board
  app.put('/boards/:bid', function(req, res) {
    Board.findByIdAndUpdate(req.params.bid, req.body, function(err) {
      if (err) return res.send(404);
      res.send(204);
    });
  });

  // Create Postit
  app.post('/boards/:bid/postits', function(req, res) {
    req.body.board_id = req.params.bid;
    var postit = new Postit(req.body);
    postit.save(function(err) {
      if(err) return res.send(err);
      res.send(201, postit);
    });
  });

  // Get postits
  app.get('/boards/:bid/postits', function(req, res) {
    var bid = req.params.bid;
    Postit.find({ board_id : bid }, function(err, postits) {
      if (err) return res.send(404);
      res.send(postits);
    });
  });

  // Get postit
  app.get('/boards/:bid/postits/:pid', loader(Postit, 'pid'), function(req, res) {
    res.send(req.postit);
  });

  // Update postit
  app.put('/boards/:bid/postits/:pid', function(req, res) {
    Postit.findByIdAndUpdate(req.params.pid, req.body, function(err) {
      if (err) return res.send(404);
      res.send(204);
    });
  });
};
