class App.SSE

  constructor: ->
    _.extend @, Backbone.Events
    source = new EventSource "/sse"
    source.addEventListener "message", @onMessage
    source.addEventListener "error",   @onError
    $(window).unload -> source.close()

  onMessage: (e) =>
    try
      msg = $.parseJSON e.data
      @trigger "#{msg.action}-#{msg.type}", msg.model
    catch err
      console.log err if window.console

  onError: (e) ->
    console.log "onError", e if window.console
