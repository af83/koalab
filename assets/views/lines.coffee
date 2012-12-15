class App.LinesView extends Backbone.View
  events:
    'drop': 'drop'

  initialize: ->
    @viewport = @options.viewport
    @listenTo @collection, 'add', @add
    @listenTo @collection, 'destroy', @destroy
    @listenTo @collection, 'reset', @fetch
    @views = []

  remove: ->
    view.remove() for view in @views
    Backbone.View.prototype.remove.call @

  render: ->
    @$(".line").remove()
    @add line for line in @collection.models
    @

  add: (line) ->
    view = new App.LineView model: line, viewport: @viewport
    @views.push view
    @$el.append view.render().el

  destroy: (line, collection, {index}) ->
    view = @views.splice(index, 1)[0]
    view.remove()

  fetch: ->
    @views = []
    @render()

  drop: (e) =>
    zoom = @viewport.get 'zoom'
    [type, cid, x, y, n] = App.Dnd.get e
    if type == "text/koalab-line"
      if el = @collection.get cid
        dx = (e.clientX - x) / zoom
        dy = (e.clientY - y) / zoom
        el.move dx, dy, @collection.board.postits.models
    else if type == "text/koalab-handle"
      if el = @collection.get cid
        dx = (e.clientX - x) / zoom
        dy = (e.clientY - y) / zoom
        coords = el.toJSON()
        coords["x#{n}"] += dx
        coords["y#{n}"] += dy
        el.save coords
    false
