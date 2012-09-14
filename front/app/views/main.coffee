# TODO use a Router instead of a view for this class
class App.MainView extends Backbone.View
  el: '#app'

  events:
    'click .board-link': 'openBoard'

  initialize: ->
    navigator.id.watch
      loggedInEmail: @model.get 'email'
      onlogin: @onLogin
      onlogout: @onLogout
    @model.on 'change', =>
      @chooseView()
      @render()
    @chooseView()

  chooseView: =>
    if @model.isLogged()
      @listBoard()
    else
      @signIn()

  render: ->
    @$el.html @view.render().el
    @

  onLogin: (assertion) =>
    @model.save assertion: assertion

  onLogout: =>
    @model.destroy()

  signIn: ->
    @view = new App.SignInView()

  listBoard: ->
    @boards = new App.BoardsCollection()
    @view = new App.ListView collection: @boards
    @boards.fetch()

  openBoard: (e) ->
    board = @boards.get e.target.dataset.id
    if board
      @view.remove()
      @view = new App.BoardView model: board
      @render()
    else
      console.log "Board not found!"
    false
