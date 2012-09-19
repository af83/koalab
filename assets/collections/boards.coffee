class App.BoardsCollection extends Backbone.Collection
  model: App.Board
  url: '/api/boards'

  initialize: ->
    App.source.on "create-board", (board) => @add board
