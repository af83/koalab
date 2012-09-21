class App.ListView extends Backbone.View
  id: 'list-view'

  events:
    'keypress #new-board': 'createOnEnter'

  initialize: ->
    @collection.on 'add', @add
    @collection.on 'reset', @fetch

  render: ->
    @$el.html JST.list boards: @collection.toJSON()
    @list = @$ "#list-of-boards"
    @input = @$ "#new-board"
    @add board for board in @collection.models
    @

  add: (board) =>
    @list.append JST.listitem board.toJSON()
    @$(".board-link").eq(-1).focus()
    @

  fetch: (boards) =>
    @list.html ''
    @add board for board in @collection.models
    @

  createOnEnter: (e) ->
    return if e.which != App.keys.enter
    title = @input.val().trim()
    @input.val ''
    model = title: title
    options = wait: true
    @collection.create model, options if title
    false
