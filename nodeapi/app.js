var path     = require('path'),
    express  = require('express'),
    mongoose = require('mongoose'),
    hamljs   = require('hamljs');

var db = mongoose.createConnection('localhost', 'password');

var app = express.createServer();
app
   .register('.haml', hamljs)
   .set('view engine', 'haml')
   .set('view options', {layout: false})
   .set('views', __dirname + '/app/views')
   .set('db', db)
   .set('models', require('app/models')(db));
