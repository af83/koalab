class App.LinesView extends Backbone.View
  id: 'lines-view'

  events:
    'dragover': 'dragover'
    'drop': 'drop'

  initialize: ->
    @viewport = @options.viewport
    @collection.on 'add', @add
    @collection.on 'reset', @fetch
    @views = []

  render: ->
    @$el.html ""
    @el.setAttribute 'dropzone', 'move string:text/line'
    @add line for line in @collection.models
    @

  add: (line) =>
    view = new App.LineView model: line, viewport: @viewport
    @views.push view
    @$el.append view.render().el

  fetch: =>
    @views = []
    @render()

  dragover: (e) =>
    e = e.originalEvent if e.originalEvent
    e.preventDefault()
    false

  drop: (e) =>
    zoom = @viewport.get 'zoom'
    e = e.originalEvent if e.originalEvent
    for type in e.dataTransfer.types
      if type == "text/line"
        [cid, x, y] = e.dataTransfer.getData(type).split(',')
        el = @collection.getByCid cid
        dx = (e.clientX - x) / zoom
        dy = (e.clientY - y) / zoom
        was = el.toJSON()
        el.set
          x1: was.x1 + dx
          y1: was.y1 + dy
          x2: was.x2 + dx
          y2: was.y2 + dy
        el.save()
    false
