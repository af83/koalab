var express = require('express'),
    pass    = require('passport'),
    errors  = require('./errors'),
    sse     = require('./sse');

var broadcast = sse(function(action, type, model) {
  return {
    action : action,
    type   : type.modelName,
    model  : model
  };
});

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

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  req.session.destroy();
  res.send(403, 'Forbidden')
}

module.exports = function(app, db, pass) {
  var models = require('./models')(db),
      Board  = models.Board,
      Postit = models.Postit,
      Line   = models.Line;

  // Show the login page
  app.get('/login', function(req, res) {
    res.render('login');
  });

  // Check the persona assertion
  app.post( '/api/user'
          , pass.authenticate( 'browserid', { failureRedirect: '/login' })
          , function(req,res) { res.send(204); }
          );

  // Show the list of boards
  // TODO pagination
  app.get('/', function(req, res) {
    if (!req.isAuthenticated()) { return res.redirect('/login'); }
    var boards = Board.find({}, function(err, boards) {
      if(err) return next(err);
      res.render('index', { boards: boards });
    });
  });

  // Create Board
  app.post('/boards', function(req, res, next) {
    if (!req.isAuthenticated()) { return res.redirect('/login'); }
    var board = new Board(req.body);
    board.save(function(err) {
      if (err) return next(err);
      res.redirect('/');
      broadcast('create', Board, board);
    });
  });

  // Show a board
  app.get('/boards/:bid', loader(Board, 'bid'), function(req, res) {
    if (!req.isAuthenticated()) { return res.redirect('/login'); }
    var bid = req.params.bid;
    Postit.find({ board_id : bid }, function(err, postits) {
      if (err) return next(new Error());
      Line.find({ board_id : bid }, function(err, lines) {
        if (err) return next(new Error());
        res.render('board', { board: JSON.stringify(req.board)
                            , postits: JSON.stringify(postits)
                            , lines: JSON.stringify(lines)
                            });
      });
    });
  });

  // Create Postit
  app.post('/api/boards/:bid/postits', ensureAuthenticated, function(req, res, next) {
    req.body.board_id = req.params.bid;
    req.body.updated_at = new Date();
    var postit = new Postit(req.body);
    postit.save(function(err) {
      if (err) return next(err);
      res.send(201, postit);
      broadcast('create', Postit, postit);
    });
  });

  // Update postit
  app.put('/api/boards/:bid/postits/:pid', ensureAuthenticated, function(req, res, next) {
    delete req.body._id;
    req.body.updated_at = new Date();
    Postit.findByIdAndUpdate(req.params.pid, req.body, function(err, postit) {
      if (err) return next(err);
      res.send(200, postit);
      broadcast('update', Postit, postit);
    });
  });

  // Create Line
  app.post('/api/boards/:bid/lines', ensureAuthenticated, function(req, res, next) {
    req.body.board_id = req.params.bid;
    var line = new Line(req.body);
    line.save(function(err) {
      if (err) return next(err);
      res.send(201, line);
      broadcast('create', Line, line);
    });
  });

  // Update line
  app.put('/api/boards/:bid/lines/:lid', ensureAuthenticated, function(req, res, next) {
    delete req.body._id;
    Line.findByIdAndUpdate(req.params.lid, req.body, function(err, line) {
      if (err) return next(err);
      res.send(200, line);
      broadcast('update', Line, line);
    });
  });

  app.get('/sse', sse.middleware());
};