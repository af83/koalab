class App.User extends Backbone.Model
  url: '/api/user'

  defaults:
    email: null

  initialize: ->
    email = document.cookie.match /email=(\w+)/
    @set email: email
    navigator.id.watch
      loggedInEmail: email
      onlogin: @onLogin
      onlogout: @onLogout

  onLogin: (assertion) =>
    @save assertion: assertion

  onLogout: =>
    @clear()

  isLogged: ->
    !! @get('email')
