class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragleave': 'leave'
    'dragend':   'end'
    'focus p': 'focus'
    'blur  p': 'blur'
    'keyup p': 'updateTitle'

  initialize: (viewport: @viewport) ->
    @viewport.on 'change',         @redraw
    @model.on 'change:title',      @update
    @model.on 'change:color',      @colorize
    @model.on 'change:coords',     @move
    @model.on 'change:size',       @resize
    @model.on 'change:angle',      @rotate
    @model.on 'change:updated_at', @updated
    fn = => @model.save {}, {silent: true}
    @throttledSave = _.throttle fn, 2000

  render: ->
    @$el.html JST.postit @model.toJSON()
    @el.id = "postit-#{@model.cid}"
    @el.querySelector('.gradient').draggable = true
    @el.querySelector('.resize').draggable = true
    @$p = @$ 'p'
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

  update: =>
    return if @inEdition
    @$p.text @model.get 'title'
    setTimeout @adjustFontSize, 0
    @

  adjustFontSize: =>
    size = 3
    w = _(@$p.text().split(/\s+/)).max (s) -> s.length
    c = @$p.clone()
           .text(w)
           .css(display: 'inline', visibility: 'hidden', fontSize: "#{size}em")
           .appendTo 'body'
    max = @model.get('size').w * @viewport.get('zoom')
    while c.width() > max
      break if size < 0.4
      size *= 0.85
      c.css fontSize: "#{size.toFixed 1}em"
    c.remove()
    p = @$p[0]
    p.style.fontSize = "#{size.toFixed 1}em"
    max = @model.get('size').h * @viewport.get('zoom') - 30
    while p.clientHeight > max
      break if size < 0.4
      size *= 0.85
      p.style.fontSize = "#{size.toFixed 1}em"
    @

  colorize: =>
    @el.style.backgroundColor = "##{@model.get 'color'}"
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

  start: (e) =>
    zoom = @viewport.get 'zoom'
    e = e.originalEvent if e.originalEvent
    if e.target.classList.contains 'resize'
      size = @model.get('size')
      x = e.clientX - size.w * zoom
      y = e.clientY - size.h * zoom
      e.dataTransfer.setData 'text/corner', "#{@model.cid},#{x},#{y}"
      e.dataTransfer.dropEffect = 'move'
    else
      coords = @viewport.toScreen @model.get('coords')
      x = e.clientX - coords.x
      y = e.clientY - coords.y
      e.dataTransfer.setData 'text/postit', "#{@model.cid},#{x},#{y}"
      e.dataTransfer.dropEffect = 'move'
      e.dataTransfer.setDragImage App.koala, 0, 0
    true

  leave: (e) =>
    e = e.originalEvent if e.originalEvent
    [cid, _, _] = e.dataTransfer.getData("text/postit").split(',')
    @el.classList.add 'moving' if @model.cid == cid
    true

  end: (e) =>
    e = e.originalEvent if e.originalEvent
    @adjustFontSize()
    @el.style.zIndex = 998
    true

  focus: =>
    @inEdition = true
    @$p.text "" if @$p.text() == App.Postit.defaultTitle
    true

  blur: =>
    @inEdition = false
    @model.set title: App.Postit.defaultTitle if @$p.text() == ''
    true

  updateTitle: (e) =>
    title = @$p.text()
    return if title == ''
    return if title == @model.get('title')
    @model.set color: '0b0b0b' if title == 'Mathilde'
    @model.set {title: title}, {silent: true}
    @adjustFontSize()
    @throttledSave()
    true
