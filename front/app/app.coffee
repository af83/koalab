@App =
  init: ->
    App.user   = new App.User()
    App.source = new App.SSE()
    App.router = new App.Router()
    Backbone.history.start pushState: true
  keys:
    enter: 13

Backbone.Model.prototype.idAttribute = "_id"

document.addEventListener "DOMContentLoaded", App.init
