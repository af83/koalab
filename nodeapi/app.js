var path     = require('path'),
    express  = require('express'),
    engines  = require('consolidate'),
    pass = require('passport'),
    BrowserID = require('passport-browserid').Strategy,
    mongoose = require('mongoose');

var app = express();
var db;


pass.serializeUser(function(user, done) {
  return done(null, user.email);
});

pass.deserializeUser(function(email, done) {
  return done(null, {
    email: email
  });
});

pass.use('browserid', new BrowserID({
  audience: 'http://koalab.lo'
}, function(email, done) {
  return done(null, {email: email });
}));

app.configure(function() {
  app.engine('haml', engines.haml);

  app.set('views', __dirname + '/app/views');
  app.set('view engine', 'haml');
  app.set('view options', {layout: false});

  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.methodOverride());
  app.use(express.session({ secret: 'koalabsecret' }));
  app.use(pass.initialize());
  app.use(pass.session());
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
  require('./app/controller')(app, db, pass);
  app.listen(process.env.PORT || 8080);
});
