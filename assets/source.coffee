class App.Source

  constructor: (board_id) ->
    _.extend @, Backbone.Events
    source = new EventSource "/api/boards/#{board_id}/sse"
    source.addEventListener "message", @onMessage
    source.addEventListener "error",   @onError
    $(window).unload -> source.close()

  onMessage: (e) =>
    try
      msg = JSON.parse e.data
      @trigger "#{msg.action}-#{msg.type}", msg.model
    catch err
      console.log err if window.console

  onError: (e) ->
    console.log "onError", e if window.console
