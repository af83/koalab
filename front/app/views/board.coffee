class App.BoardView extends Backbone.View
  id: 'board-view'

  events:
    'click #add-postit': 'addPostit'
    'click #add-line': 'addLine'
    'click .toggle-menu': 'toggleMenu'

  initialize: ->
    @lines = new App.LinesView model: @model
    @postits = new App.PostitsView collection: @model.postits
    @model.postits.fetch()

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

  toggleMenu: ->
    console.log 'toggleMenu'
    @$el.find('aside').toggleClass 'closed'
    false
