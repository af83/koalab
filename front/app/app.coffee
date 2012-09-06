@App =
  init: ->
    App.Boards.push new App.Board()
    list = new App.ListView collection: App.Boards
    list.render()

@JST = {}

document.addEventListener "DOMContentLoaded", App.init
