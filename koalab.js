var fs             = require('fs'),
  crypto         = require('crypto'),
  express        = require('express'),
  bodyParser     = require('body-parser'),
  cookieParser   = require('cookie-parser'),
  cookieSession  = require('cookie-session'),
  methodOverride = require('method-override'),
  pass           = require('passport'),
  BrowserID      = require('passport-browserid').Strategy,
  mongoose       = require('mongoose');

var config,
    authorized = [];

function abort() {
  console.log.apply(console, arguments);
  process.exit(1);
}

(function loadConfig() {
  try {
    config = require('./config/server.json');
  } catch(e) {
    abort("Can't load config/server.json");
  }

  var example = ["example@example.net", "*@example.com"];
  if (!config.authorized || !config.authorized.length) {
    abort("Authorized is missing in config/server.json");
  }
  if (config.authorized.join() == example.join()) {
    abort("Authorized is not configured in config/server.json");
  }
  if (!config.port) {
    abort("Port is not configured in config/server.json");
  }
  if (!config.persona || !config.persona.audience) {
    abort("Persona audience is not configured in config/server.json");
  }
})();

(function prepareAuthorizedRegexps() {
  for (var i = 0, l = config.authorized.length; i < l; i++) {
    var pattern = config.authorized[i]
                        .replace(/[-[\]{}()+?.,\\^$|#\s]/g, "\\$&")
                        .replace("*", ".*");
    authorized.push(RegExp('^' + pattern + '$'));
  }
})();

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
    audience: config.persona.audience
  },
  function(email, done) {
    for (var i = 0, l = authorized.length; i < l; i++) {
      if (authorized[i].test(email)) {
        return done(null, { email: email });
      }
    }
    done(null, false);
  }
));

useSecret(function(secret) {
  var app = express();
  app.set('view engine', 'jade');
  app.set('views', __dirname + '/app/views');

  app
    .use(express.static(__dirname + '/public'))
    .use(bodyParser())
    .use(cookieParser())
    .use(cookieSession({secret: secret}))
    .use(pass.initialize())
    .use(pass.session())
    .use(methodOverride());

  // development error handler
  // will print stacktrace
  if (app.get('env') === 'development') {
      app.use(function(err, req, res, next) {
          res.status(err.status || 500);
          res.render('error', {
              message: err.message,
              error: err
          });
      });
  }

  // production error handler
  // no stacktraces leaked to user
  app.use(function(err, req, res, next) {
      res.status(err.status || 500);
      res.render('error', {
          message: err.message,
          error: {}
      });
  });

  var uri = process.env.MONGOLAB_URI ||
    process.env.MONGOHQ_URL ||
    config.mongodb.host + "/" + config.mongodb.database;
  var db = mongoose.createConnection(uri);
  db.on('error', function(err) {
    abort("Can't connect to mongodb: ", err);
  });

  var port = process.env.PORT || config.port;
  db.once('open', function () {
    require('./app/controller')(app, db, pass, config.demo);
    app.listen(port, function() {
      console.log('Express server listening on port ' + port);
    });
  });
});
