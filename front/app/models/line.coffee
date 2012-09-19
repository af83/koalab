class App.Line extends Backbone.Model
  defaults:
    x1: 0
    x2: 0
    y1: 0
    y2: 0

  dX: ->
    @get('x2') - @get('x1')

  dY: ->
    @get('y2') - @get('y1')

  length: ->
    [x, y] = [@dX(), @dY()]
    Math.sqrt(x*x + y*y)

  angle: ->
    radians = Math.atan(@dY() / @dX())
    radians * 180 / Math.PI
