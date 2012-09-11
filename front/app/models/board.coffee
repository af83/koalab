class App.Board extends Backbone.Model
  defaults: ->
    title: "Foobar"
    lines: []

  initialize: ->
    @postits = new App.PostitsCollection
    @postits.board = @

  addPostit: (color) ->
    @postits.create color: color

  addLine: (dir) ->
    l = 200 * @get("lines").length
    line = switch dir
      when 'horizontal' then line = x1: 0, y1: l, x2: 1500, y2: l
      when 'vertical'   then line = x1: l, y1: 0, x2: l, y2: 1000
      when 'diagonal'   then line = x1: l, y1: 0, x2: l+1000, y2: 1000
    @get("lines").push line
    @trigger "add:lines", line
    @save()
