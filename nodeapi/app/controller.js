var express = require('express'),
    models  = app.get('models'),

    Board  = models.Board,
    Postit = models.Postit,
    Rules  = models.Rules;

app.use(express.bodyParser());

function loader(Model) {
  return function(req, res, next, id) {
    Model.findById(id, function(err, model) {
      if (err) {
        next(err);
      } else {
        req[Model.modelName] = model;
        next();
      }
    });
  };
}

app.param('board_id', loader(Board));
app.param('postit_id', loader(Postit));

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
    res.send(200);
  });
});

// Get Board
app.get('/boards/:board_id', function(req, res) {
  res.send(req.board);
});

// Update Board
app.put('/boards/:board_id', function(req, res) {
});

// Create Postit
app.post('/boards/:board_id/postits', function(req, res) {
  var postit = new Postit(req.body);
  postit.save(function(err) {
    if(err) return res.send(err);
    res.send(200);
  });
});

// List postits
app.get('/boards/:board_id/postits', function(req, res) {
  var board_id = req.params.board_id;
  Postit.find({ board_id : board_id }, function(err, postits) {
    if (err) return res.send(404);
    res.send(postits);
  });
});

// Get postit
app.get('/boards/:board_id/postits/:postit_id', function(req, res) {
  res.send(req.postit);
});

// Update postit
app.put('/boards/:board_id/postits/:postit_id', function(req, res) {
});
