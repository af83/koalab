class App.Board extends Backbone.Model
  url: ->
    "/api/boards/#{@id}"

  defaults: ->
    title: "Foobar"

  initialize: ->
    source = new App.Source @id
    @postits = new App.PostitsCollection source
    @postits.board = @
    @lines = new App.LinesCollection source
    @lines.board = @
