@App =
  init: (board) ->
    view = new App.BoardView model: board
    ($ '#app').append view.render().el
  keys:
    enter: 13

Backbone.Model.prototype.idAttribute = "_id"
