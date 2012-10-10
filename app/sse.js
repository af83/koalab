// Number of events in the history
var HISTO_S = 100;

var emitter = new (require('events').EventEmitter)(),
    histo   = [],
    offset  = 0,
    count   = 0;

// Default is 10
emitter.setMaxListeners(Infinity);

function sse(builder) {
  return function(data) {
    if (builder) {
      data = builder.apply(builder, arguments);
    }

    var msg = newMessage(count, null, data);
    emitter.emit('message', msg);

    ++count;

    if (histo.push(msg) === HISTO_S + 1) {
      setTimeout(cleanHistory, 500);
    }
  };
}

function newMessage(id, event, data) {
  if ('string' === typeof data) {
    data = data.split(/\n/).join('\ndata: ');
  } else if (data) {
    data = JSON.stringify(data, null, '');
  }
  return {
    id    : id,
    event : event,
    data  : data
  };
}

function cleanHistory() {
  var diff = histo.length - HISTO_S;
  histo = histo.slice(diff);
  offset += diff;
}

function middleware() {
  function init(req, res) {
    req.socket.setTimeout(Infinity);
    res.writeHead(200, {
      'Content-Type'  : 'text/event-stream',
      'Cache-Control' : 'no-cache',
      'Connection'    : 'keep-alive'
    });
    res.write('\n');
  }

  function newSender(res) {
    return function(msg) {
      var id    = msg.id,
          data  = msg.data,
          event = msg.event;
      if (id || id === 0) res.write('id: ' + id + '\n');
      if (event) res.write('event: ' + event + '\n');
      if (data)  res.write('data: '  + data  + '\n');
      res.write('\n');
    };
  }

  return function(req, res) {
    init(req, res);

    var sender = newSender(res);
    emitter.addListener('message', sender);

    var ping = setInterval(function() { res.write('::\n\n'); }, 30000);

    req.on('close', function() {
      clearInterval(ping);
      emitter.removeListener('message', sender);
    });

    var lastEventId = parseInt(req.headers['last-event-id'], 10);
    if (!isNaN(lastEventId)) {
      var next = lastEventId + 1;
      if (next < offset) next = offset;
      if (next < count) {
        for (var i = next; i < count; i++) {
          sender(histo[i - offset]);
        }
      }
    }
  };
}

exports = module.exports = sse;
exports.middleware = middleware;
