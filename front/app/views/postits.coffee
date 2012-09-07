class App.PostitsView extends Backbone.View
  id: 'postits-view'

  events:
    'dragover': 'dragover'
    'drop': 'drop'

  initialize: ->
    @collection.on 'add', @add
    @views = []
    @views.push new App.PostitView model: m for m in @collection

  render: ->
    @$el.html ''
    @el.setAttribute 'dropzone', 'move string:text/postit'
    @$el.append view.render().el for view in @views
    @

  add: (postit) =>
    view = new App.PostitView model: postit
    @views.push view
    @$el.append view.render().el

  dragover: (e) =>
    e = e.originalEvent if e.originalEvent
    e.preventDefault()
    false

  drop: (e) =>
    e = e.originalEvent if e.originalEvent
    [cid, x, y] = e.dataTransfer.getData("text/postit").split(',')
    el = document.getElementById "postit-#{cid}"
    el.style.left = "#{e.clientX - x}px"
    el.style.top  = "#{e.clientY - y}px"
    el.classList.remove 'moving'
    false
