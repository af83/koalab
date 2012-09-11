class App.Postit extends Backbone.Model
  defaults: ->
    title: App.Postit.defaultTitle
    color: "ccc"
    coords: { x: 150, y: 150 }
    size:   { w: 150, h: 150 }
    angle: Math.floor(Math.random() * 100) / 10 - 5

App.Postit.defaultTitle = "New post-it"
