class App.LinesView extends Backbone.View
  id: 'lines-view'

  initialize: ->
    @model.on 'add:lines', @add

  render: ->
    @$el.html ""
    @add line for line in @model.get "lines"
    @

  add: (line) =>
    @$el.append JST.line line
