class App.LineView extends Backbone.View
  className: 'line'

  events:
    'dragstart':   'start'
    'touchstart':  'touchstart'
    'touchcancel': 'touchcancel'
    'touchmove':   'touchmove'
    'touchend':    'touchend'

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

  touchstart: (e) =>
    return if @moving
    e = e.originalEvent if e.originalEvent
    e.preventDefault()   # Prevent image drag
    e.stopPropagation()  # Avoid touchstart on the BoardView
    touch = e.changedTouches[0]
    contact = @viewport.fromScreen x: touch.pageX, y: touch.pageY
    @moving =
      x1: contact.x - @model.get 'x1'
      y1: contact.y - @model.get 'y1'
      x2: contact.x - @model.get 'x2'
      y2: contact.y - @model.get 'y2'
      id: touch.identifier
    false

  touchmove: (e) =>
    return unless @moving
    e = e.originalEvent if e.originalEvent
    if e.changedTouches.identifiedTouch
      touch = e.changedTouches.identifiedTouch @moving.id
    else  # Seems like chrome don't implement identifiedTouch
      touch = t for t in e.changedTouches when t.identifier == @moving.id
    if touch
      contact = @viewport.fromScreen x: touch.pageX, y: touch.pageY
      @model.set
        x1: contact.x - @moving.x1
        y1: contact.y - @moving.y1
        x2: contact.x - @moving.x2
        y2: contact.y - @moving.y2
    true

  touchcancel: =>
    @moving = null
    true

  touchend: =>
    return unless @moving
    @moving = null
    @model.save()
    true
