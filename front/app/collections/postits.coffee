class App.PostitsCollection extends Backbone.Collection
  model: App.Postit
  url: ->
    "#{@board.url()}/postits"
