@App =
  init: (board) ->
    view = new App.BoardView model: board
    ($ '#app').append view.render().el

Backbone.Model.prototype.idAttribute = "_id"
