class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'focus p':     'focus'
    'blur  p':     'blur'
    'keyup p':     'updateTitle'
    'dragstart':   'dragstart'
    'dragleave':   'dragleave'
    'dragend':     'dragend'
    'touchstart':  'touchstart'
    'touchcancel': 'touchcancel'
    'touchmove':   'touchmove'
    'touchend':    'touchend'

  initialize: (viewport: @viewport) ->
    @viewport.on 'change:zoom',    @redraw
    @viewport.on 'change:offset',  @move
    @model.on 'change:title',      @update
    @model.on 'change:color',      @colorize
    @model.on 'change:coords',     @move
    @model.on 'change:size',       @resize
    @model.on 'change:angle',      @rotate
    @model.on 'change:updated_at', @updated
    fn = => @model.save {}, {silent: true}
    @throttledSave = _.throttle fn, 2000
    @el.id = "postit-#{@model.cid}"

  render: ->
    @$el.html JST.postit @model.toJSON()
    @buildSelector()
    @update()
    @colorize()
    @move()
    @resize()
    @rotate()
    @bringOut()
    @

  redraw: =>
    @move()
    @resize()
    @adjustFontSize()
    @

  buildSelector: ->
    @p        = @el.querySelector 'p'
    @shadow   = @el.querySelector '.shadow'
    @gradient = @el.querySelector '.gradient'
    @

  update: =>
    return if @inEdition
    @p.textContent = @model.get 'title'
    setTimeout @adjustFontSize, 0
    @

  # TODO make this function a jQuery plugin
  adjustFontSize: =>
    size = 3
    w = _(@p.textContent.split(/\s+/)).max (s) -> s.length
    c = @p.cloneNode true
    c.textContent = w
    c.style.display = 'inline'
    c.style.visibility = 'hidden'
    c.style.fontSize = "#{size}em"
    document.body.appendChild c
    max = @model.get('size').w * @viewport.get('zoom')
    while c.scrollWidth > max
      break if size < 0.4
      size *= 0.85
      c.style.fontSize = "#{size.toFixed 1}em"
    document.body.removeChild c
    @p.style.fontSize = "#{size.toFixed 1}em"
    max = @model.get('size').h * @viewport.get('zoom')
    while @p.scrollHeight > max
      break if size < 0.4
      size *= 0.85
      @p.style.fontSize = "#{size.toFixed 1}em"
    @

  colorize: =>
    c = App.Colors.mix (@model.get 'color'), '#000000', 0.9
    gradient = "linear-gradient(top, #{c} 0%, ##{@model.get 'color'} 75%)"
    @gradient.style.background = "-moz-#{gradient}"
    @gradient.style.background = "-webkit-#{gradient}"
    @gradient.style.background = gradient
    @el.classList.add 'reverse' if @model.get('color')[0] == '0'
    @

  move: =>
    coords = @viewport.toScreen @model.get "coords"
    @el.style.left = "#{coords.x}px"
    @el.style.top  = "#{coords.y}px"
    @el.classList.remove 'moving'
    @

  resize: =>
    size = @model.get "size"
    zoom = @viewport.get "zoom"
    @el.style.width  = "#{size.w * zoom}px"
    @el.style.height = "#{size.h * zoom}px"
    offset = 2 + Math.floor size.h * zoom / 40
    radius = Math.floor size.h * zoom / 15
    @shadow.style.boxShadow = "-#{offset}px 0 #{radius}px #999"
    @

  rotate: =>
    prop = "rotate(#{@model.get 'angle'}deg)"
    @el.style.MozTransform = prop
    @el.style.WebkitTransform = prop
    @el.style.transform = prop
    @

  bringOut: =>
    @el.style.zIndex = @model.collection.indexOf @model
    @

  updated: =>
    @model.collection.sort silent: true
    @model.collection.trigger 'sort'
    @

  dragstart: (e) =>
    zoom = @viewport.get 'zoom'
    e = e.originalEvent if e.originalEvent
    if e.target.classList.contains 'resize'
      size = @model.get('size')
      x = e.clientX - size.w * zoom
      y = e.clientY - size.h * zoom
      e.dataTransfer.setData 'text/corner', "#{@model.cid},#{x},#{y}"
    else
      coords = @viewport.toScreen @model.get('coords')
      x = e.clientX - coords.x
      y = e.clientY - coords.y
      e.dataTransfer.setData 'text/postit', "#{@model.cid},#{x},#{y}"
      e.dataTransfer.setDragImage App.koala, 0, 0
    e.dataTransfer.dropEffect = 'move'
    true

  dragleave: (e) =>
    e = e.originalEvent if e.originalEvent
    [cid, _, _] = e.dataTransfer.getData("text/postit").split(',')
    @el.classList.add 'moving' if @model.cid == cid
    true

  dragend: =>
    @adjustFontSize()
    @el.style.zIndex = 998
    true

  touchstart: (e) =>
    e = e.originalEvent if e.originalEvent
    e.preventDefault()  # Prevent image drag
    data = if e.touches then e.touches[0] else e
    @startTouch = x: data.pageX, y: data.pageY
    false

  touchmove: (e) =>
    e = e.originalEvent if e.originalEvent
    data = if e.touches then e.touches[0] else e
    @stopTouch = x: data.pageX, y: data.pageY
    true

  touchcancel: =>
    @startTouch = @stopTouch = null
    true

  touchend: (e) =>
    return unless @startTouch and @stopTouch
    zoom = @viewport.get 'zoom'
    x = (@stopTouch.x - @startTouch.x) / zoom
    y = (@stopTouch.y - @startTouch.y) / zoom
    @model.move x, y
    @startTouch = @stopTouch = null
    @dragend()

  focus: =>
    @inEdition = true
    @p.textContent = "" if @p.textContent == App.Postit.defaultTitle
    true

  blur: =>
    @inEdition = false
    @model.set title: App.Postit.defaultTitle if @p.textContent == ''
    true

  updateTitle: (e) =>
    title = @p.textContent
    return if title == ''
    return if title == @model.get('title')
    @model.set color: '0b0b0b' if title == 'Mathilde'
    @model.set {title: title}, {silent: true}
    @adjustFontSize()
    @throttledSave()
    true
