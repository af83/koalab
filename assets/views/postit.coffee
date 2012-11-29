Padding =
  top: 25
  left: 5
  right: 5
  bottom: 5

class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dblclick':              'nextColor'
    'doubleTap':             'nextColor'
    'focus p':               'focus'
    'blur  p':               'blur'
    'keyup p':               'updateTitle'
    'keydown p':             'editTitle'
    'dragstart':             'dragstart'
    'dragend':               'dragend'
    'dragcancel':            'dragcancel'
    'touchstart  .gradient': 'touchstart'
    'touchcancel .gradient': 'touchcancel'
    'touchmove   .gradient': 'touchmove'
    'touchend    .gradient': 'touchend'

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

  dispose: ->
    @viewport.off null, null, @
    Backbone.View.prototype.dispose.call @

  render: ->
    @$el.html JST.postit @model.toJSON()
    @buildSelector()
    @p.textContent = @model.get 'title'
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

  adjustFontSize: =>
    size = @model.get 'size'
    zoom = @viewport.get 'zoom'
    width = (size.w - Padding.left - Padding.right) * zoom
    height = (size.h - Padding.top - Padding.bottom) * zoom
    App.FontSize.adjust @p, width, height
    @

  colorize: =>
    c = App.Colors.mix (@model.get 'color'), '#000000', 0.9
    colors = "#{c} 0%, ##{@model.get 'color'} 75%"
    @gradient.style.background = "-webkit-linear-gradient(top, #{colors})"
    @gradient.style.background = "linear-gradient(to bottom, #{colors})"
    @el.classList.add 'reverse' if @model.get('color')[0] == '0'
    @

  move: =>
    coords = @viewport.toScreen @model.get "coords"
    @el.style.left = "#{coords.x}px"
    @el.style.top  = "#{coords.y}px"
    @

  resize: =>
    size = @model.get "size"
    zoom = @viewport.get "zoom"
    @el.style.width  = "#{size.w * zoom}px"
    @el.style.height = "#{size.h * zoom}px"
    @el.style.padding = """
      #{Padding.top * zoom}px
      #{Padding.right * zoom}px
      #{Padding.bottom * zoom}px
      #{Padding.right * zoom}px
    """
    offset = 2 + Math.floor size.h * zoom / 40
    radius = Math.floor size.h * zoom / 15
    @shadow.style.boxShadow = "-#{offset}px 0 #{radius}px #999"
    @adjustFontSize()
    @

  rotate: =>
    prop = "rotate(#{@model.get 'angle'}deg)"
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

  nextColor: ->
    @model.nextColor()

  dragstart: (e) =>
    if e.target.classList.contains 'resize'
      zoom = @viewport.get 'zoom'
      size = @model.get 'size'
      x = e.clientX / zoom - size.w
      y = e.clientY / zoom - size.h
      App.Dnd.set e, 'text/koalab-corner', @model.cid, x, y
    else
      contact = @viewport.fromScreen x: e.clientX, y: e.clientY
      topleft = @model.get 'coords'
      x = contact.x - topleft.x
      y = contact.y - topleft.y
      @el.classList.add 'moving'
      App.Dnd.set e, 'text/koalab-postit', @model.cid, x, y
    @el.style.zIndex = 998
    e.dataTransfer.dropEffect = 'move'
    true

  dragend: =>
    @el.classList.remove 'moving'
    true

  dragcancel: =>
    @el.classList.remove 'moving'
    true

  touchstart: (originalEvent: e) =>
    return if @resizing
    e.preventDefault()   # Prevent image drag
    e.stopPropagation()  # Avoid touchstart on the BoardView
    if @moving
      one = App.Touch.find e.touches, @moving.id
      two = e.changedTouches[0]
      @moving = null
    else if e.changedTouches.length >= 2
      one = e.changedTouches[0]
      two = e.changedTouches[1]
    if one and two
      zoom = @viewport.get 'zoom'
      size = @model.get 'size'
      [one, two] = [two, one] if two.pageX < one.pageX
      @resizing =
        x: (two.pageX - one.pageX) / zoom - size.w
        y: (two.pageY - one.pageY) / zoom - size.h
        id1: one.identifier
        id2: two.identifier
    else
      touch = e.changedTouches[0]
      contact = @viewport.fromScreen x: touch.pageX, y: touch.pageY
      topleft = @model.get 'coords'
      @moving =
        x: contact.x - topleft.x
        y: contact.y - topleft.y
        id: touch.identifier
    @el.classList.add 'moving'
    @el.style.zIndex = 998
    false

  touchmove: (originalEvent: e) =>
    if @resizing
      one = App.Touch.find e.touches, @resizing.id1
      two = App.Touch.find e.touches, @resizing.id2
      if one and two
        zoom = @viewport.get 'zoom'
        @model.set size:
          w: (two.pageX - one.pageX) / zoom - @resizing.x
          h: (two.pageY - one.pageY) / zoom - @resizing.y
    else if @moving
      touch = App.Touch.find e.changedTouches, @moving.id
      if touch
        contact = @viewport.fromScreen x: touch.pageX, y: touch.pageY
        @model.set coords:
          x: contact.x - @moving.x
          y: contact.y - @moving.y
    true

  touchcancel: =>
    return unless @moving or @resizing
    @resizing = null
    @moving = null
    @el.classList.remove 'moving'
    true

  touchend: =>
    return unless @moving or @resizing
    @model.save()
    @touchcancel()

  focus: =>
    @inEdition = true
    if @p.textContent == App.Postit.defaultTitle
      @p.textContent = ""
      if $.browser.webkit
        range = document.createRange()
        range.selectNodeContents @p
        sel = window.getSelection()
        sel.removeAllRanges()
        sel.addRange range
    true

  blur: =>
    @inEdition = false
    @p.textContent = App.Postit.defaultTitle if @p.textContent == ''
    true

  editTitle: (originalEvent: e) =>
    e.stopPropagation?()

  updateTitle: =>
    title = @p.textContent
    return if title == ''
    return if title == @model.get('title')
    @model.set color: '0b0b0b' if title == 'Mathilde'
    @model.set {title: title}, {silent: true}
    @adjustFontSize()
    @throttledSave()
    true
