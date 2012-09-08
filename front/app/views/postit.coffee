class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragleave': 'leave'
    'dragend': 'end'

  initialize: ->
    @model.on 'change:color',  @colorize
    @model.on 'change:coords', @move

  render: ->
    @el.id = "postit-#{@model.cid}"
    @el.draggable = true
    @$el.html JST.postit @model.toJSON()
    @move()
    @colorize()
    @

  colorize: =>
    @el.style.backgroundColor = "##{@model.get 'color'}"
    @

  move: =>
    coords = @model.get "coords"
    console.log 'move', coords, @el
    @el.style.left = "#{coords.x}px"
    @el.style.top  = "#{coords.y}px"
    @el.classList.remove 'moving'
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
