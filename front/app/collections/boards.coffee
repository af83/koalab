class App.BoardsCollection extends Backbone.Collection
  model: App.Board
  url: '/boards'

  initialize: ->
    App.source.on "create-board", (board) => @add board
