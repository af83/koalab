class App.Router extends Backbone.Router
  routes:
    'login': 'index'
    '': 'list'
    'boards/:id': 'show'

  initialize: ->
    App.user.on 'change', @change
    @main = new App.MainView model: App.user
    @main.boards.add window.board if window.board

  change: =>
    if App.user.isLogged()
      @navigate 'boards', trigger: true
    else
      @navigate '', trigger: true

  index: =>
    @main.signIn().render()

  list: =>
    @main.listBoards().render()

  show: (id) =>
    @main.showBoard(id).render()
