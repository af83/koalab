class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragleave': 'leave'
    'dragend': 'end'
    'focus p': 'focus'
    'blur p': 'blur'
    'keypress p': 'saveOnEnter'

  initialize: ->
    @model.on 'change:title',  @update
    @model.on 'change:color',  @colorize
    @model.on 'change:coords', @move
    @model.on 'change:size',   @resize
    @model.on 'change:angle',  @rotate

  render: ->
    @el.id = "postit-#{@model.cid}"
    @update()
    @colorize()
    @move()
    @resize()
    @rotate()
    @

  update: =>
    @$el.html JST.postit @model.toJSON()
    @el.querySelector('.gradient').draggable = true
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
    true

  focus: =>
    p = @$el.find('p')
    p.text "" if p.text() == App.Postit.defaultTitle
    true

  blur: =>
    @model.set title: @$el.find('p').text()
    @model.set title: App.Postit.defaultTitle if @model.get('title') == ''
    @model.set color: '0b0b0b' if @model.get('title') == 'Mathilde'
    @model.save()
    true

  saveOnEnter: (e) =>
    return if e.which != App.keys.enter
    @$el.find('p').blur()
    false
