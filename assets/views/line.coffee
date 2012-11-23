class App.LineView extends Backbone.View
  className: 'line'

  events:
    'dragstart': 'start'

  initialize: (viewport: @viewport) ->
    @viewport.on 'change', @move
    @model.on    'change', @update

  dispose: ->
    @viewport.off null, null, @
    Backbone.View.prototype.dispose.call @

  render: =>
    @$el.html JST.line
    @update()
    @

  update: =>
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
    @el.style.WebkitTransform = "rotate(#{angle}deg) translateZ(0)"
    @el.style.transform = "rotate(#{angle}deg)"
    @

  start: (e) =>
    e = e.originalEvent if e.originalEvent
    x = e.clientX
    y = e.clientY
    if e.target.classList.contains 'handle'
      side = if e.target.classList.contains 'start' then 1 else 2
      App.Dnd.set e, 'text/koalab-handle', @model.cid, x, y, side
    else
      App.Dnd.set e, 'text/koalab-line', @model.cid, x, y, 0
    e.dataTransfer.dropEffect = 'move'
    true
