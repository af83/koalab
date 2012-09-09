class App.LinesView extends Backbone.View
  id: 'lines-view'

  initialize: ->
    @model.on 'add:lines', @add

  render: ->
    @$el.html ""
    @add line for line in @model.get "lines"
    @

  add: (line) =>
    x = line.x2 - line.x1
    y = line.y2 - line.y1
    line.length = Math.floor Math.sqrt(x*x + y*y)
    line.angle = Math.atan y/x
    line.angle = -line.angle * 180 / Math.PI
    @$el.append JST.line line
