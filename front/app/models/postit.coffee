class App.Postit extends Backbone.Model
  defaults: ->
    title: App.Postit.defaultTitle
    color: "ccc"
    coords: { x: 150, y: 150 }
    size:   { w: 150, h: 150 }

App.Postit.defaultTitle = "New post-it"
