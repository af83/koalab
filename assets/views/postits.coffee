class App.PostitsView extends Backbone.View
  id: 'postits-view'

  events:
    'dragover': 'dragover'
    'drop': 'drop'

  initialize: ->
    @viewport = @options.viewport
    @collection.on 'add', @add
    @collection.on 'reset', @fetch
    @collection.on 'sort', @sort
    @views = []

  render: ->
    @$el.html ''
    @el.setAttribute 'dropzone', 'move string:text/postit string:text/corner'
    @add postit for postit in @collection.models
    @

  add: (postit) =>
    view = new App.PostitView model: postit, viewport: @viewport
    @views.push view
    @$el.append view.render().el

  fetch: =>
    @views = []
    @render()

  sort: =>
    view.bringOut() for view in @views

  dragover: (e) =>
    e = e.originalEvent if e.originalEvent
    e.preventDefault()
    for type in e.dataTransfer.types
      if type == "text/corner"
        [cid, x, y] = e.dataTransfer.getData(type).split(',')
        el = @collection.getByCid cid
        zoom = @viewport.get 'zoom'
        el.set size:
          w: (e.clientX - x) / zoom
          h: (e.clientY - y) / zoom
    false

  drop: (e) =>
    zoom = @viewport.get 'zoom'
    e = e.originalEvent if e.originalEvent
    for type in e.dataTransfer.types
      if type == "text/corner"
        [cid, x, y] = e.dataTransfer.getData(type).split(',')
        el = @collection.getByCid cid
        el.set size:
          w: (e.clientX - x) / zoom
          h: (e.clientY - y) / zoom
        el.save()
      else if type == "text/postit"
        [cid, x, y] = e.dataTransfer.getData(type).split(',')
        el = @collection.getByCid cid
        coords = @viewport.fromScreen
          x: e.clientX - x
          y: e.clientY - y
        el.set coords: coords
        el.save()
    false
