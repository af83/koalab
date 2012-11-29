class App.PostitsView extends Backbone.View
  events:
    'dragover': 'dragover'
    'drop': 'drop'

  initialize: ->
    @viewport = @options.viewport
    @collection.on 'add', @add
    @collection.on 'destroy', @destroy
    @collection.on 'reset', @fetch
    @collection.on 'sort', @sort
    @views = []

  dispose: ->
    @viewport.off null, null, @
    Backbone.View.prototype.dispose.call @

  remove: ->
    view.remove() for view in @views
    Backbone.View.prototype.remove.call @

  render: ->
    @$(".postit").remove()
    @add postit for postit in @collection.models
    @

  add: (postit) =>
    view = new App.PostitView model: postit, viewport: @viewport
    @views.push view
    @$el.append view.render().el

  destroy: (postit, collection, {index}) =>
    view = @views.splice(index, 1)[0]
    view.remove()

  fetch: =>
    @views = []
    @render()

  sort: =>
    view.bringOut() for view in @views

  dragover: (e) =>
    e.preventDefault()
    [type, cid, x, y] = App.Dnd.get e
    if type == "text/koalab-corner"
      zoom = @viewport.get 'zoom'
      if el = @collection.getByCid cid
        el.set size:
          w: e.clientX / zoom - x
          h: e.clientY / zoom - y
    else if type == "text/koalab-postit"
      contact = @viewport.fromScreen x: e.clientX, y: e.clientY
      if el = @collection.getByCid cid
        el.set coords:
          x: contact.x - x
          y: contact.y - y
    false

  drop: (e) =>
    zoom = @viewport.get 'zoom'
    [type, cid, x, y] = App.Dnd.get e
    if type == "text/koalab-corner"
      if el = @collection.getByCid cid
        el.save size:
          w: e.clientX / zoom - x
          h: e.clientY / zoom - y
    else if type == "text/koalab-postit"
      contact = @viewport.fromScreen x: e.clientX, y: e.clientY
      if el = @collection.getByCid cid
        el.save coords:
          x: contact.x - x
          y: contact.y - y
    false
