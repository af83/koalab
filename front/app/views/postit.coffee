class App.PostitView extends Backbone.View
  tagName: 'article'
  className: 'postit'

  events:
    'dragstart': 'start'
    'dragover': 'over'

  initialize: ->
    @el.draggable = true
    @el.style.backgroundColor = "##{@model.get 'color'}"

  render: ->
    @$el.html JST.postit @model.toJSON()
    @

  start: (e) =>
    @el.classList.add 'moving'
    e = e.originalEvent
    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData 'id', @model.id
    true

  over: (e) =>
    console.log 'over'
    @el.classList.remove 'moving'
    false
