class App.LinesView extends Backbone.View
  id: 'lines-view'

  initialize: ->
    @collection.on 'add', @add
    @collection.on 'reset', @fetch
    @views = []
    @views.push new App.LineView model: m for m in @collection.models

  render: ->
    @$el.html ""
    @$el.append view.render().el for view in @views
    @

  add: (line) =>
    view = new App.LineView model: line
    @views.push view
    @$el.append view.render().el

  fetch: =>
    @views = []
    @views.push new App.LineView model: m for m in @collection.models
    @render()
