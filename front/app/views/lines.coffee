class App.LinesView extends Backbone.View
  id: 'lines-view'

  initialize: ->
    @viewport = @options.viewport
    @collection.on 'add', @add
    @collection.on 'reset', @fetch
    @views = []

  render: ->
    @$el.html ""
    @add line for line in @collection.models
    @

  add: (line) =>
    view = new App.LineView model: line, viewport: @viewport
    @views.push view
    @$el.append view.render().el

  fetch: =>
    @views = []
    @render()
