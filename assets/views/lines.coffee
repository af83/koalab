class App.LinesView extends Backbone.View
  events:
    'drop': 'drop'

  initialize: ->
    @viewport = @options.viewport
    @collection.on 'add', @add
    @collection.on 'reset', @fetch
    @views = []

  render: ->
    @$(".line").remove()
    @add line for line in @collection.models
    @

  add: (line) =>
    view = new App.LineView model: line, viewport: @viewport
    @views.push view
    @$el.append view.render().el

  fetch: =>
    @views = []
    @render()

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
