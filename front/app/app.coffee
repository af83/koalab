@App =
  init: ->
    boards = new App.BoardsCollection()
    list = new App.ListView collection: boards
    list.render()

@JST = {}

document.addEventListener "DOMContentLoaded", App.init
