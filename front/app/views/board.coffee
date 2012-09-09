class App.BoardView extends Backbone.View
  id: 'board-view'

  events:
    'click #add-postit-blue': 'addPostitBlue'
    'click #add-postit-green': 'addPostitGreen'
    'click #add-postit-yellow': 'addPostitYellow'
    'click #add-postit-rose': 'addPostitRose'
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

  addPostit: (color) ->
    @model.addPostit color
    false

  addPostitBlue: ->
    @addPostit '3fa1f3'

  addPostitGreen: ->
    @addPostit '7ef45f'

  addPostitYellow: ->
    @addPostit 'f0fa78'

  addPostitRose: ->
    @addPostit 'f878d2'

  addLine: ->
    @model.addLine
    false

  toggleMenu: ->
    @$el.find('aside').toggleClass 'closed'
    false
