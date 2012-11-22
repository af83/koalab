class App.PostitsCollection extends Backbone.Collection
  model: App.Postit

  url: ->
    "#{@board.url()}/postits"

  initialize: (source) ->
    source.on "create-postit", (postit) => @add postit
    source.on "update-postit", (postit) => @get(postit._id)?.set postit
    source.on "delete-postit", (postit) => @get(postit._id)?.destroy()

  comparator: (postit) ->
    postit.get 'updated_at'
