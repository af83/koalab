// Number of events in the history
var HISTO_S = 10;

var emitter = new (require('events').EventEmitter)(),
    histo   = {},
    count   = 0;

// Default is 10
emitter.setMaxListeners(1024);

function broadcast(board_id, data) {
  var msg = {
    id: count++,
    data: JSON.stringify(data, null, '')
  };

  var h = histo[board_id] = histo[board_id] || [];
  if (h.push(msg) > HISTO_S) {
    h.shift();
  }

  emitter.emit(board_id, msg);
}

function middleware(req, res, next) {
  var board_id = req.params.bid,
      interval;

  if (!('string' === typeof board_id && 24 === board_id.length)) {
    return next();
  }

  function sender(msg) {
    res.write('id: ' + msg.id + '\ndata: ' + msg.data + '\n\n');
  }

  function clean() {
    clearInterval(interval);
    emitter.removeListener(board_id, sender);
  }

  function ping() {
    res.write(':\n');
  }

  req.socket.setTimeout(Infinity);
  req.on('end',   clean); // closed by server
  req.on('close', clean); // closed by client

  res.writeHead(200, {
    'Content-Type'  : 'text/event-stream',
    'Cache-Control' : 'no-cache',
    'Connection'    : 'keep-alive'
  });
  res.write('\n');

  interval = setInterval(ping, 30000);
  emitter.addListener(board_id, sender);

  var lastEventId = parseInt(req.headers['last-event-id'], 10);
  if (!isNaN(lastEventId)) {
    var messages = histo[board_id] || [];
    for (var i = 0, l = messages.length; i < l; i++) {
      var msg = messages[i];
      if (msg.id > lastEventId) { sender(msg); }
    }
  }
}

module.exports = {
  broadcast: broadcast,
  middleware: middleware
};
