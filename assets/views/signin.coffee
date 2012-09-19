class App.SignInView extends Backbone.View
  id: 'signin-view'

  events:
    'click .signin': 'requestAssertion'

  render: ->
    @$el.html JST.signin()
    @

  requestAssertion: ->
    navigator.id.request siteName: 'Koalab'
    false
