var express = require('express');

app.use(express.bodyParser());

app.get('/boards', function(req, res) {
  res.send(200);
});

app.get('/boards/:id', function(req, res) {
  res.render('index');
});

