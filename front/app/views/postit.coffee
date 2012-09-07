class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragleave': 'leave'
    'dragend': 'end'

  initialize: ->
    @el.id = "postit-#{@model.cid}"
    @el.draggable = true
    @el.style.backgroundColor = "##{@model.get 'color'}"

  render: ->
    @$el.html JST.postit @model.toJSON()
    @el.style.left = "0px"
    @el.style.top  = "0px"
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
