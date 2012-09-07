# TODO use a Router instead of a view for this class
class App.MainView extends Backbone.View
  el: '#app'

  events:
    'click .board-link': 'openBoard'

  initialize: ->
    @boards = new App.BoardsCollection()  # FIXME
    @view = new App.ListView collection: @boards

  render: ->
    @$el.html @view.render().el
    @

  openBoard: (e) ->
    board = @boards.get e.target.dataset.id
    if board
      @view.remove()
      @view = new App.BoardView model: board
      @render()
    else
      console.log "Board not found!"
    false
