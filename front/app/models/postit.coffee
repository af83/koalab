class App.Postit extends Backbone.Model
  defaults: ->
    title: App.Postit.defaultTitle
    color: "ccc"
    coords:
      x: 50 + Math.floor(Math.random() * 100)
      y: 50 + Math.floor(Math.random() * 100)
    size:
      w: 150
      h: 150
    angle: Math.floor(Math.random() * 150) / 10 - 7

App.Postit.defaultTitle = "New post-it"
