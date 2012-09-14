class App.MainView extends Backbone.View
  el: '#app'

  events:
    'click .board-link': 'openBoard'

  initialize: ->
    @boards = new App.BoardsCollection()

  render: ->
    @$el.html @view.render().el
    @

  signIn: ->
    @view.remove() if @view
    @view = new App.SignInView()
    @

  listBoards: ->
    @view.remove() if @view
    @view = new App.ListView collection: @boards
    @boards.fetch()
    @

  showBoard: (id) ->
    board = @boards.get id
    if board
      @view.remove() if @view
      @view = new App.BoardView model: board
    else
      console.log "Board not found!"
    @

  openBoard: (e) ->
    App.router.navigate e.target.pathname.slice(1), trigger: true
    false
