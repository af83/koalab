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

  fitToContent: (board, width, height, border=50) ->
    postits = board.postits.models
    return if postits.length == 0
    xcoords = _.map postits, (p) -> p.get('coords').x + p.get('size').w
    xcoords = xcoords.concat _.map postits, (p) -> p.get('coords').x
    xmax = _.max xcoords
    xmin = _.min xcoords
    xzoom = (width - 2*border) / (xmax - xmin)
    ycoords = _.map postits, (p) -> p.get('coords').y + p.get('size').h
    ycoords = ycoords.concat _.map postits, (p) -> p.get('coords').y
    ymax = _.max ycoords
    ymin = _.min ycoords
    yzoom = (height - 2*border) / (ymax - ymin)
    zoom = _.min [xzoom, yzoom]
    @set
      zoom: zoom
      offset:
        x: zoom * xmin - border
        y: zoom * ymin - border
