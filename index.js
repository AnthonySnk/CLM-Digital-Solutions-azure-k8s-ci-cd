var express = require('express');
var app = express();
var root = {
    msg: "ApiRest prueba",
};
var public = {
    public_token: "12837asd98a7sasd97a9sd7",
};
var private = {
    private_token: "TWFudGVuIGxhIENsYW1hIHZhcyBtdXkgYmllbgo=",
};
app.get('/', function (req, res) {
  res.send(root);
});

app.get('/public', function (req, res) {
  res.send(public);
});

app.get('/private', function (req, res) {
  res.send(private);
});

app.listen(3000, '0.0.0.0', function () {
  console.log('Example app listening on port 3000!');
});
