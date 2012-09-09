var path     = require('path'),
    express  = require('express'),
    engines  = require('consolidate'),
    mongoose = require('mongoose');

var app = express();
var db;

app.configure(function() {
  app.engine('haml', engines.haml);

  app.set('views', __dirname + '/app/views');
  app.set('view engine', 'haml');
  app.set('view options', {layout: false});

  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);

  db = mongoose.createConnection('localhost', 'koalab');
});

app.configure('development', 'test', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function() {
  app.use(express.errorHandler());
});

db.once('open', function () {
  require('./app/controller')(app, db);
  app.listen(process.env.PORT || 8080);
});
