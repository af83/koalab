class App.ListView extends Backbone.View
  el: '#app'

  initialize: ->

  render: ->
    console.log "render", @collection, @
    @$el.html JST.list boards: @collection.toJSON()
    @
