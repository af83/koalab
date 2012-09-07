class App.PostitsView extends Backbone.View
  id: 'postits-view'

  initialize: ->
    @collection.on 'add', @add
    @views = []
    @views.push new App.PostitView model: m for m in @collection

  render: ->
    @$el.html ""
    @$el.append view.render().el for view in @views
    @

  add: (postit) =>
    view = new App.PostitView model: postit
    @views.push view
    @$el.append view.render().el
