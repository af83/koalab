var express = require('express'),
    models  = app.get('models'),

    Board  = models.Board,
    Postit = models.Postit,
    Rules  = models.Rules;

app.use(express.bodyParser());

function loader(Model) {
  return function(req, res, next, id) {
    Model.findOne({ title : id }, function(err, model) {
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
  req.board.update();
});

// Create Postit
app.post('/boards/:board_id/postits', function(req, res) {
  res.send(req.board.postits);
});

// List postits
app.get('/boards/:board_id/postits', function(req, res) {
});

// Get postit
app.get('/boards/:board_id/postits/:postit_id', function(req, res) {
});

// Update postit
app.put('/boards/:board_id/postits/:postit_id', function(req, res) {
});
