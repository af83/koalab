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
        el.move dx, dy, @collection.board.postits.models
      else if type == "text/handle"
        [cid, x, y, n] = e.dataTransfer.getData(type).split(',')
        el = @collection.getByCid cid
        dx = (e.clientX - x) / zoom
        dy = (e.clientY - y) / zoom
        coords = {}
        coords["x#{n}"] = dx + el.get "x#{n}"
        coords["y#{n}"] = dy + el.get "y#{n}"
        el.save coords
    false
