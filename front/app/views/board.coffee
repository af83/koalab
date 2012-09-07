class App.BoardView extends Backbone.View
  id: 'board-view'

  events:
    'click #add-postit': 'addPostit'
    'click #add-line': 'addLine'

  initialize: ->
    @lines = new App.LinesView collection: @model.get("lines")
    @postits = new App.PostitsView collection: @model.get("postits")

  render: ->
    @$el.html JST.board @model.toJSON()
    @$el.append @lines.render().el
    @$el.append @postits.render().el
    @

  addPostit: ->
    @model.addPostit()
    false

  addLine: ->
    @model.addLine()
    false
