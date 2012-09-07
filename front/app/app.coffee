@App =
  init: ->
    main = new App.MainView()
    main.render()

@JST = {}

document.addEventListener "DOMContentLoaded", App.init
