class App.LineView extends Backbone.View
  className: 'line'

  events:
    'dragstart': 'start'

  initialize: (viewport: @viewport) ->
    @viewport.on 'change', @move
    @model.on    'change', @render

  render: =>
    @$el.html JST.line
    @move()
    @rotate()
    @

  move: =>
    len = @model.length() * @viewport.get('zoom')
    coords = @viewport.toScreen
      x: @model.get('x1')
      y: @model.get('y1')
    @el.draggable = true
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

  start: (e) =>
    e = e.originalEvent if e.originalEvent
    x = e.clientX
    y = e.clientY
    if e.target.classList.contains 'handle'
      side = if e.target.classList.contains 'start' then 1 else 2
      e.dataTransfer.setData 'text/handle', "#{@model.cid},#{x},#{y},#{side}"
    else
      e.dataTransfer.setData 'text/line', "#{@model.cid},#{x},#{y}"
    e.dataTransfer.dropEffect = 'move'
    true
