class App.LinesView extends Backbone.View
  id: 'lines-view'

  initialize: ->
    @collection.on 'add', @add

  render: ->
    @$el.html ""
    @add line for line in @collection
    @

  add: (line) =>
    @$el.append JST.line line.toJSON()
