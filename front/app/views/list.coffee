class App.ListView extends Backbone.View
  id: 'list-view'

  events:
    'keypress #new-board': 'createOnEnter'

  initialize: ->
    @collection.on 'add', @add
    @collection.on 'reset', @fetch

  render: ->
    @$el.html JST.list boards: @collection.toJSON()
    @list = @$el.find "#list-of-boards"
    @input = @$el.find "#new-board"
    @add board for board in @collection
    @

  add: (board) =>
    @list.append JST.listitem board.toJSON()
    @$el.find(".board-link:last").focus()
    @

  fetch: (boards) =>
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
