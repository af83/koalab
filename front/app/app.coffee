@App =
  init: ->
    App.source = new App.SSE()
    main = new App.MainView()
    main.render()
  keys:
    enter: 13

@JST = {}

Backbone.Model.prototype.idAttribute = "_id"

document.addEventListener "DOMContentLoaded", App.init
