class App.User extends Backbone.Model
  url: '/api/user'

  defaults:
    email: null

  initialize: ->
    navigator.id.watch
      loggedInUser: @get 'email'
      onlogin: @onLogin
      onlogout: @onLogout

  onLogin: (assertion) =>
    @save assertion: assertion

  onLogout: =>
    @clone.destroy()
    @clear()

  isLogged: ->
    !! @get('email')
