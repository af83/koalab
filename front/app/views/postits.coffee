class App.PostitsView extends Backbone.View
  id: 'postits-view'

  events:
    'dragover': 'dragover'
    'drop': 'drop'

  initialize: ->
    @collection.on 'add', @add
    @collection.on 'reset', @fetch
    @views = []
    @views.push new App.PostitView model: m for m in @collection.models

  render: ->
    @$el.html ''
    @el.setAttribute 'dropzone', 'move string:text/postit'
    @$el.append view.render().el for view in @views
    @

  add: (postit) =>
    view = new App.PostitView model: postit
    @views.push view
    @$el.append view.render().el

  fetch: =>
    @views = []
    @views.push new App.PostitView model: m for m in @collection.models
    @render()

  dragover: (e) =>
    e = e.originalEvent if e.originalEvent
    e.preventDefault()
    false

  drop: (e) =>
    e = e.originalEvent if e.originalEvent
    [cid, x, y] = e.dataTransfer.getData("text/postit").split(',')
    el = @collection.getByCid cid
    el.set coords:
      x: e.clientX - x
      y: e.clientY - y
    el.save()
    false
