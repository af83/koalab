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

  move: (dx, dy, postits) ->
    was = @toJSON()
    now =
      x1: was.x1 + dx
      y1: was.y1 + dy
      x2: was.x2 + dx
      y2: was.y2 + dy
    @set now
    @save()
    a = x: was.x1, y: was.y1
    b = x: was.x2, y: was.y2
    c = x: now.x1, y: now.y1
    d = x: now.x2, y: now.y2
    for p in postits when p.intersects a, b, c, d
      p.move dx, dy
