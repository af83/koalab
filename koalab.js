var fs        = require('fs'),
    crypto    = require('crypto'),
    express   = require('express'),
    pass      = require('passport'),
    BrowserID = require('passport-browserid').Strategy,
    mongoose  = require('mongoose');

var db, app = express();

function useSecret(callback) {
  fs.readFile('.secret', 'utf8', function(err, secret) {
    if (!err) { return callback(secret); }
    crypto.randomBytes(48, function(err, buf) {
      secret = buf.toString('hex');
      fs.writeFile('.secret', secret, 'utf8');
      callback(secret);
    });
  });
}

pass.serializeUser(function(user, done) {
  return done(null, user.email);
});

pass.deserializeUser(function(email, done) {
  return done(null, { email: email });
});

pass.use('browserid', new BrowserID({
    audience: 'http://localhost:8080'
  },
  function(email, done) {
    process.nextTick(function () {
      return done(null, { email: email });
    });
  }
));

useSecret(function(secret) {
  app.configure(function() {
    app.set('port', process.env.PORT || 8080);
    app.set('view engine', 'jade');
    app.set('views', __dirname + '/app/views');

    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({ secret: secret }));
    app.use(pass.initialize());
    app.use(pass.session());
    app.use(express.methodOverride());
    app.use(app.router);

    db = mongoose.createConnection('localhost', 'koalab');
  });

  app.configure('development', function() {
    app.use(express.static(__dirname + '/public'));
    app.use(express.logger('dev'));
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  });

  app.configure('production', function() {
    app.use(express.errorHandler());
  });

  db.once('open', function () {
    require('./app/controller')(app, db, pass);
    app.listen(app.get('port'), function() {
      console.log('Express server listening on port ' + app.get('port'));
    });
  });
});
