class App.Board extends Backbone.Model
  defaults: ->
    title: "Foobar"

  initialize: ->
    @postits = new App.PostitsCollection
    @postits.board = @
    @lines = new App.LinesCollection
    @lines.board = @
