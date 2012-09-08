function extendError(Err, name, status) {
  Err.prototype = new Error();
  Err.prototype.constructor = Err;
  Err.prototype.name = name;
  Err.prototype.status = status;
}

function NotFound() {
  Error.apply(this, arguments);
}
extendError(NotFound, 'NotFound', 404);

function BadRequest() {
  Error.apply(this, arguments);
}
extendError(BadRequest, 'BadRequest', 400);

module.exports = {
  NotFound : NotFound,
  BadRequest : BadRequest
};
