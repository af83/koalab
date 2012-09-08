class App.Postit extends Backbone.Model
  defaults: ->
    title: "New post-it"
    color: "ccc"
    coords: { x: 150, y: 150 }
    size:   { w: 150, h: 150 }
