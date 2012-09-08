var path     = require('path'),
    express  = require('express'),
    engines = require('consolidate'),
    mongoose = require('mongoose');

var app = express();
app.engine('haml', engines.haml)
     .set('view engine', 'haml')
     .set('view options', {layout: false})
     .set('views', __dirname + '/app/views');

var db = mongoose.createConnection('localhost', 'boardz');

db.once('open', function () {
  app.set('models', require('./app/models')(db));

  require('./app/controller')(app);

  app.listen(process.env.PORT || 8080);
});
