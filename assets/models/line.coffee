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
    a = radians * 180 / Math.PI
    a += 180 if @dX() < 0
    a

  move: (dx, dy, postits) ->
    was = @toJSON()
    now =
      x1: was.x1 + dx
      y1: was.y1 + dy
      x2: was.x2 + dx
      y2: was.y2 + dy
    @save now
