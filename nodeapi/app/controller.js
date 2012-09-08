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

module.exports = function(app) {
  var models  = app.get('models'),

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
  app.get('/boards/:board_id', loader(Board, 'board_id'), function(req, res) {
    res.send(req.board);
  });

  // Update Board
  app.put('/boards/:board_id', function(req, res) {
    Board.findByIdAndUpdate(req.params.board_id, req.body, function(err) {
      if (err) return res.send(404);
      res.send(204);
    });
  });

  // Create Postit
  app.post('/boards/:board_id/postits', function(req, res) {
    req.body.board_id = req.params.board_id;
    var postit = new Postit(req.body);
    postit.save(function(err) {
      if(err) return res.send(err);
      res.send(201, postit);
    });
  });

  // Get postits
  app.get('/boards/:board_id/postits', function(req, res) {
    var board_id = req.params.board_id;
    Postit.find({ board_id : board_id }, function(err, postits) {
      if (err) return res.send(404);
      res.send(postits);
    });
  });

  // Get postit
  app.get('/boards/:board_id/postits/:postit_id', loader(Postit, 'postit_id'), function(req, res) {
    res.send(req.postit);
  });

  // Update postit
  app.put('/boards/:board_id/postits/:postit_id', function(req, res) {
    Postit.findByIdAndUpdate(req.params.postit_id, req.body, function(err) {
      if (err) return res.send(404);
      res.send(204);
    });
  });
};