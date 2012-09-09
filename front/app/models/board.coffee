class App.Board extends Backbone.Model
  defaults: ->
    title: "Foobar"
    lines: []

  initialize: ->
    @postits = new App.PostitsCollection
    @postits.board = @

  addPostit: (color) ->
    @postits.create color: color

  addLine: ->
    y = 100 * @get("lines").length
    line = x1: 0, y1: y, x2: 1000, y2: y
    @get("lines").push line
    @trigger "add:lines", line
    @save()
