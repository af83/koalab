class App.PostitsCollection extends Backbone.Collection
  model: App.Postit
  url: ->
    "#{@board.url()}/postits"

  initialize: ->
    App.source.on "create-postit", (postit) =>
      @add postit if postit.board_id == @board.id
    App.source.on "update-postit", (postit) =>
      @get(postit._id).set postit if postit.board_id == @board.id
