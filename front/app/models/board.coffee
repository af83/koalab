class App.Board extends Backbone.Model
  defaults:
    title: "Foobar"

  initialize: ->
    @set lines: new App.LinesCollection()
    @postits = new App.PostitsCollection()

  addPostit: ->
    @postits.create(title: "New postit")

  addLine: ->
    y = 100 * @get("lines").length
    @get("lines").create x1: 0, y1: y, x2: 1000, y2: y
