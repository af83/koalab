var path      = require('path'),
    express   = require('express'),
    Sequelize = require('sequelize'),
    hamljs    = require('hamljs');

var db  = new Sequelize('database', 'root', null, {
      dialect: 'sqlite',
      storage: __dirname + '/db/test.db',
      sync: { force: true },
      define : {underscored: true} //column created_at instead of createdAt
    });

var app = express.createServer();
app
   .register('.haml', hamljs)
   .set('view engine', 'haml')
   .set('view options', {layout: false})
   .set('views', __dirname + '/app/views')
   .set('db', db)
   .set('models', require('app/models')(db, Sequelize));
