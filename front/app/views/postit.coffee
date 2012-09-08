class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragleave': 'leave'
    'dragend': 'end'
    'dblclick': 'randomColor'

  initialize: ->
    @model.on 'change:color',  @colorize
    @model.on 'change:coords', @move
    @model.on 'change:size',   @resize

  render: ->
    @el.id = "postit-#{@model.cid}"
    @el.draggable = true
    @$el.html JST.postit @model.toJSON()
    @colorize()
    @move()
    @resize()
    @

  colorize: =>
    @el.style.backgroundColor = "##{@model.get 'color'}"
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

  start: (e) =>
    e = e.originalEvent if e.originalEvent
    x = e.clientX - parseInt @el.style.left, 10
    y = e.clientY - parseInt @el.style.top, 10
    e.dataTransfer.setData 'text/postit', "#{@model.cid},#{x},#{y}"
    e.dataTransfer.dropEffect = 'move'
    true

  leave: (e) =>
    @el.classList.add 'moving'
    true

  end: (e) =>
    e = e.originalEvent if e.originalEvent
    true

  randomColor: =>
    colors = ["f00", "349", "333", "9fb"]
    i = Math.floor(Math.random() * (colors.length + 1))
    @model.set color: colors[i]
    @model.save()
    true
