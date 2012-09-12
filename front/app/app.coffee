@App =
  init: ->
    App.source = new App.SSE()
    main = new App.MainView model: App.User.current()
    main.render()
  keys:
    enter: 13

Backbone.Model.prototype.idAttribute = "_id"

document.addEventListener "DOMContentLoaded", App.init
