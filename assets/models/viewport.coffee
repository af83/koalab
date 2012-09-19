class App.Viewport extends Backbone.Model
  defaults: ->
    zoom: 1
    offset:
      x: 0
      y: 0

  toScreen: (coords) ->
    o = @get 'offset'
    z = @get 'zoom'
    x = z * coords.x - o.x
    y = z * coords.y - o.y
    x: x, y: y

  fromScreen: (coords) ->
    o = @get 'offset'
    z = @get 'zoom'
    x = (coords.x + o.x) / z
    y = (coords.y + o.y) / z
    x: x, y: y
