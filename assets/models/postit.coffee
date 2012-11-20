class App.Postit extends Backbone.Model
  defaults: ->
    title: App.Postit.defaultTitle
    color: "ccc"
    coords:
      x: 50 + Math.floor(Math.random() * 100)
      y: 50 + Math.floor(Math.random() * 100)
    size:
      w: 160
      h: 160
    angle: (Math.random() * 15).toFixed(1) - 7

  move: (dx, dy) ->
    was = @get 'coords'
    @save coords:
      x: was.x + dx
      y: was.y + dy

App.Postit.defaultTitle = "New post-it"
