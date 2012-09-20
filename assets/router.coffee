class App.Router extends Backbone.Router
  routes:
    '': 'list'
    'boards/:id': 'show'
    'login': 'login'

  initialize: ->
    App.user.on 'change', @change
    @main = new App.MainView model: App.user
    @main.boards.add window.board if window.board

  change: =>
    if App.user.isLogged()
      @navigate 'login', trigger: true
    else
      @navigate '', trigger: true

  login: =>
    @main.signIn().render()

  list: =>
    @main.listBoards().render()

  show: (id) =>
    @main.showBoard(id).render()
