var express = require('express'),
    pass = require('passport'),
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

module.exports = function(app, db, pass) {
    var models = require('./models')(db),
        Board  = models.Board,
        Postit = models.Postit,
        Lines  = models.Lines;

    app.post("/api/user",  pass.authenticate('browserid', {
        successRedirect: '/',
        failureRedirect: '/',
        failureFlash: true
    })); 

//    app.get('/', function(req, res) {
//        res.render('index');
//    });

    app.get('/api/boards', function(req, res, next) {
        var boards = Board.find({}, function(err, boards) {
            if(err) return next(err);
            res.send(boards);
        });
    });

    // Create Board
    app.post('/api/boards', function(req, res, next) {
        var board = new Board(req.body);
        board.save(function(err) {
            if (err) return next(err);
            res.send(201, board);
            broadcast('create', Board, board);
        });
    });

    // Get Board
    app.get('/api/boards/:bid', loader(Board, 'bid'), function(req, res) {
        res.send(req.board);
    });

    // Update Board
    app.put('/api/boards/:bid', function(req, res, next) {
        delete req.body._id;
        Board.findByIdAndUpdate(req.params.bid, req.body, function(err, board) {
            if (err) return next(err);
            res.send(200, board);
            broadcast('update', Board, board);
        });
    });

    // Create Postit
    app.post('/api/boards/:bid/postits', function(req, res, next) {
        req.body.board_id = req.params.bid;
        var postit = new Postit(req.body);
        postit.save(function(err) {
            if (err) return next(err);
            res.send(201, postit);
            broadcast('create', Postit, postit);
        });
    });

    // Get postits
    app.get('/api/boards/:bid/postits', function(req, res, next) {
        var bid = req.params.bid;
        Postit.find({ board_id : bid }, function(err, postits) {
            if (err) return next(new Error());
            res.send(postits);
        });
    });

    // Get postit
    app.get('/api/boards/:bid/postits/:pid', loader(Postit, 'pid'), function(req, res) {
        res.send(req.postit);
    });

    // Update postit
    app.put('/api/boards/:bid/postits/:pid', function(req, res, next) {
        delete req.body._id;
        Postit.findByIdAndUpdate(req.params.pid, req.body, function(err, postit) {
            if (err) return next(err);
            res.send(200, postit);
            broadcast('update', Postit, postit);
        });
    });

    app.get('/sse', sse.middleware());
};
