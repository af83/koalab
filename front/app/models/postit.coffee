class App.Postit extends Backbone.Model
  defaults: ->
    title: "New post-it"
    color: "ccc"
    coords: { x: 200, y: 200 }
    size:   { w: 200, h: 200 }
