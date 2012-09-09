@App =
  init: ->
    App.source = new App.SSE()
    main = new App.MainView()
    main.render()

@JST = {}

Backbone.Model.prototype.idAttribute = "_id"

document.addEventListener "DOMContentLoaded", App.init
