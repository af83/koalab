class App.ListView extends Backbone.View
  id: 'list-view'

  events:
    'keypress #new-board': 'createOnEnter'

  initialize: ->
    @collection.on 'add', @add
    # FIXME @id is just a hack to have ids.
    # Remove it when the Rest API will be available
    @id = 0

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

  createOnEnter: (e) ->
    return if e.which != 13  # ENTER_KEY
    title = @input.val().trim()
    @input.val ''
    @collection.create id: @id++, title: title if title
    false
