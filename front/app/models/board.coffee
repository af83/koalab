class App.Board extends Backbone.Model
  defaults:
    title: "Foobar"

  initialize: ->
    @set lines: []
    @postits = new App.PostitsCollection
    @postits.board = @

  addPostit: ->
    @postits.create(title: "New postit")

  addLine: ->
    y = 100 * @get("lines").length
    line = x1: 0, y1: y, x2: 1000, y2: y
    @get("lines").push line
    @trigger "add:lines", line
    @save()
