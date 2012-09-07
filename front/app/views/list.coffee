class App.ListView extends Backbone.View
  el: '#app'

  events:
    'keypress #new-board': 'createOnEnter'
    'click .board-link': 'openBoard'

  initialize: ->
    @collection.on 'add', @add
    # FIXME @id is just a hack to have ids.
    # Remove it when the Rest API will be available
    @id = 0

  render: ->
    @$el.html JST.list boards: @collection.toJSON()
    @list = $ "#list-of-boards"
    @input = $ "#new-board"
    @

  add: (board) =>
    @list.append JST.listitem board.toJSON()
    @

  openBoard: (e) ->
    console.log $(e.target).data "id"
    false

  createOnEnter: (e) ->
    return if e.which != 13  # ENTER_KEY
    title = @input.val().trim()
    @input.val ''
    @collection.create id: @id++, title: title if title
    false
