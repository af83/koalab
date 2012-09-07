var express = require('express');

app.use(express.bodyParser())
   .use(uagent.express());

app.get('/boards/', function(req, res) {
});

app.get('/boards/:id', function(req, res) {
  res.render('index');
});

app.get('/boards/:id', function(req, res) {
  res.render('index');
});

app.get('/monitor', function(req, res) {
  res.render('monitor');
});
