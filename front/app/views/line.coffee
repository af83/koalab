class App.LineView extends Backbone.View
  className: 'line'

  initialize: (viewport: @viewport) ->
    @viewport.on 'change', @move
    @model.on    'change', @render

  render: =>
    @move()
    @rotate()
    @

  move: =>
    len = @model.length() * @viewport.get('zoom')
    coords = @viewport.toScreen
      x: @model.get('x1')
      y: @model.get('y1')
    @el.style.left = "#{coords.x}px"
    @el.style.top  = "#{coords.y}px"
    @el.style.width = "#{Math.floor len}px"
    @

  rotate: ->
    angle = @model.angle()
    @el.style.MozTransform = "rotate(#{angle}deg)"
    @el.style.WebkitTransform = "rotate(#{angle}deg)"
    @el.style.transform = "rotate(#{angle}deg)"
    @
