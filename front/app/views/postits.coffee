class App.PostitsView extends Backbone.View
  id: 'postits-view'

  initialize: ->
    @collection.on 'add', @add

  render: ->
    @$el.html ""
    @add postit for postit in @collection
    @

  add: (postit) =>
    console.log postit.toJSON()
    @$el.append JST.postit postit.toJSON()
