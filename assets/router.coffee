class App.Router extends Backbone.Router
  routes:
    'login': 'index'
    '': 'list'
    'boards/:id': 'show'

  initialize: ->
    @main = new App.MainView model: App.user
    App.user.on 'change', @change

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
