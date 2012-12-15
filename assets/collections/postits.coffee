class App.PostitsCollection extends Backbone.Collection
  model: App.Postit

  url: ->
    "#{@board.url()}/postits"

  initialize: (source) ->
    @listenTo source, "create-postit", (postit) -> @add postit
    @listenTo source, "update-postit", (postit) -> @get(postit._id)?.set postit
    @listenTo source, "delete-postit", (postit) -> @get(postit._id)?.destroy()

  comparator: (postit) ->
    postit.get 'updated_at'
