class App.Source

  constructor: (board_id) ->
    _.extend @, Backbone.Events

    connect = =>
      source = new EventSource "/api/boards/#{board_id}/sse"
      source.addEventListener "message", @onMessage
      source.addEventListener "error",   @onError
      $(window).unload -> source.close()

    # A workaround for ipad bug when using Server-Sent Events
    if $.os.ipad
      $(window).on 'load', =>
        setTimeout connect, 1000
    else
      connect()

  onMessage: (e) =>
    try
      msg = JSON.parse e.data
      @trigger "#{msg.action}-#{msg.type}", msg.model
    catch err
      console.log err if window.console

  onError: (e) ->
    console.log "onError", e if window.console
