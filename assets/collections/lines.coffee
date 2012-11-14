InitialOffset = 20
SpaceBetweenLines = 320
DefaultLength = SpaceBetweenLines * 5

class App.LinesCollection extends Backbone.Collection
  model: App.Line

  url: ->
    "#{@board.url()}/lines"

  initialize: ->
    App.source.on "create-line", (line) =>
      @add line if line.board_id == @board.id
    App.source.on "update-line", (line) =>
      @get(line._id).set line if line.board_id == @board.id

  exists: (attrs) ->
    !! @find (line) ->
      attrs.x1 == line.get('x1') &&
      attrs.x2 == line.get('x2') &&
      attrs.y1 == line.get('y1') &&
      attrs.y2 == line.get('y2')

  createHorizontal: ->
    attrs =
      x1: InitialOffset
      y1: InitialOffset
      x2: InitialOffset + DefaultLength
      y2: InitialOffset
    while @exists attrs
      attrs.y1 = attrs.y2 += SpaceBetweenLines
    @create attrs

  createVertical: ->
    attrs =
      x1: InitialOffset
      y1: InitialOffset
      x2: InitialOffset
      y2: InitialOffset + DefaultLength
    while @exists attrs
      attrs.x1 = attrs.x2 += SpaceBetweenLines
    @create attrs

  createDiagonal: ->
    attrs =
      x1: InitialOffset
      y1: InitialOffset
      x2: InitialOffset + DefaultLength
      y2: InitialOffset + DefaultLength
    while @exists attrs
      attrs.x1 = attrs.x2 += SpaceBetweenLines
    @create attrs
