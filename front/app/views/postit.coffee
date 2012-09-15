class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragleave': 'leave'
    'dragend': 'end'
    'focus p': 'focus'
    'keyup p': 'updateTitle'

  initialize: ->
    @model.on 'change:title',  @update
    @model.on 'change:color',  @colorize
    @model.on 'change:coords', @move
    @model.on 'change:size',   @resize
    @model.on 'change:angle',  @rotate
    fn = => @model.save {}, {silent: true}
    @throttledSave = _.throttle fn, 2000

  render: ->
    @$el.html JST.postit @model.toJSON()
    @el.id = "postit-#{@model.cid}"
    @el.querySelector('.gradient').draggable = true
    @el.querySelector('.resize').draggable = true
    @update()
    @colorize()
    @move()
    @resize()
    @rotate()
    @

  update: =>
    @$el.find('p').text @model.get 'title'
    setTimeout @adjustFontSize, 0
    @

  adjustFontSize: =>
    size = 3
    p = @$el.find 'p'
    w = _(p.text().split(/\s+/)).max (s) -> s.length
    c = p.clone()
         .text(w)
         .css(display: 'inline', visibility: 'hidden', fontSize: "#{size}em")
         .appendTo 'body'
    p = p[0]
    while c.width() > @model.get('size').w
      break if size < 0.4
      size *= 0.85
      c.css fontSize: "#{size.toFixed 1}em"
    c.remove()
    p.style.fontSize = "#{size.toFixed 1}em"
    while p.clientHeight > @model.get('size').h - 30  # 30px for margins
      break if size < 0.4
      size *= 0.85
      p.style.fontSize = "#{size.toFixed 1}em"
    @

  colorize: =>
    @el.style.backgroundColor = "##{@model.get 'color'}"
    @el.classList.add 'reverse' if @model.get('color')[0] == '0'
    @

  move: =>
    coords = @model.get "coords"
    @el.style.left = "#{coords.x}px"
    @el.style.top  = "#{coords.y}px"
    @el.classList.remove 'moving'
    @

  resize: =>
    size = @model.get "size"
    @el.style.width  = "#{size.w}px"
    @el.style.height = "#{size.h}px"
    @

  rotate: =>
    prop = "rotate(#{@model.get 'angle'}deg)"
    @el.style.MozTransform = prop
    @el.style.WebkitTransform = prop
    @el.style.transform = prop
    @

  start: (e) =>
    e = e.originalEvent if e.originalEvent
    if e.target.classList.contains 'resize'
      x = e.clientX - @model.get('size').w
      y = e.clientY - @model.get('size').h
      e.dataTransfer.setData 'text/corner', "#{@model.cid},#{x},#{y}"
      e.dataTransfer.dropEffect = 'move'
    else
      x = e.clientX - parseInt @el.style.left, 10
      y = e.clientY - parseInt @el.style.top, 10
      e.dataTransfer.setData 'text/postit', "#{@model.cid},#{x},#{y}"
      e.dataTransfer.dropEffect = 'move'
      img = document.createElement 'img'
      img.src = '/images/koala.png'
      e.dataTransfer.setDragImage img, 0, 0
    true

  leave: (e) =>
    e = e.originalEvent if e.originalEvent
    [cid, _, _] = e.dataTransfer.getData("text/postit").split(',')
    @el.classList.add 'moving' if @model.cid == cid
    true

  end: (e) =>
    e = e.originalEvent if e.originalEvent
    @adjustFontSize()
    true

  focus: =>
    p = @$el.find('p')
    p.text "" if p.text() == App.Postit.defaultTitle
    true

  updateTitle: (e) =>
    title = @$el.find('p').text()
    title = App.Postit.defaultTitle if title == ''
    return if title == @model.get('title')
    @model.set color: '0b0b0b' if title == 'Mathilde'
    @model.set {title: title}, {silent: true}
    @adjustFontSize()
    @throttledSave()
    true
