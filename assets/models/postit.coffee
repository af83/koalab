class App.Postit extends Backbone.Model
  defaults: ->
    title: App.Postit.defaultTitle
    color: "ccc"
    coords:
      x: 0
      y: 0
    size:
      w: 160
      h: 160
    angle: (Math.random() * 15).toFixed(1) - 7

  move: (dx, dy) ->
    was = @get 'coords'
    @save coords:
      x: was.x + dx
      y: was.y + dy

  nextColor: ->
    colors = _.values App.Postit.colors
    index  = 1 + colors.indexOf @get 'color'
    @save color: colors[index % colors.length]

App.Postit.defaultTitle = "New post-it"
App.Postit.colors =
  yellow: 'f0fa78'
  blue: '3fa1f3'
  green: '7ef45f'
  rose: 'f878f2'
