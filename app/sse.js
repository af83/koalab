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
  emitter.emit(board_id, msg);

  histo[board_id] = histo[board_id] || [];
  var diff = histo[board_id].push(msg) - HISTO_S;
  if (diff > 0) { histo[board_id].slice(diff); }
}

function middleware(req, res, next) {
  var board_id = req.params.bid;
  if (!('string' === typeof board_id && 24 === board_id.length)) {
    return next();
  }

  req.socket.setTimeout(Infinity);
  res.writeHead(200, {
    'Content-Type'  : 'text/event-stream',
    'Cache-Control' : 'no-cache',
    'Connection'    : 'keep-alive'
  });
  res.write('\n');

  var sender = function(msg) {
    res.write('id: ' + msg.id + '\ndata: '  + msg.data  + '\n\n');
  };
  emitter.addListener(board_id, sender);

  var ping = setInterval(function() { res.write('::\n\n'); }, 30000);

  req.on('close', function() {
    clearInterval(ping);
    emitter.removeListener(board_id, sender);
  });

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
