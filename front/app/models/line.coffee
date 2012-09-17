class App.Line extends Backbone.Model
  defaults:
    x1: 0
    x2: 0
    y1: 0
    y2: 0

  length: ->
    [x, y] = [@x2 - @x1, @y2 - @y1]
    Math.sqrt(x*x + y*y)

  angle: ->
    ratio = (@y2 - @y1) / (@x2 - @x1)
    radians = Math.atan ratio
    radians * 180 / Math.PI
