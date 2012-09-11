class App.LinesView extends Backbone.View
  id: 'lines-view'

  initialize: ->
    @model.on 'add:lines', @add

  render: ->
    @$el.html ""
    @add line for line in @model.get "lines"
    @

  # TODO create a LineView
  # TODO create a Line model and move length/angle in it
  add: (line) =>
    x = line.x2 - line.x1
    y = line.y2 - line.y1
    length = Math.floor Math.sqrt(x*x + y*y)
    angle = Math.atan(y/x) * 180 / Math.PI
    el = document.createElement 'div'
    el.classList.add 'line'
    el.style.left = "#{line.x1}px"
    el.style.top  = "#{line.y1}px"
    el.style.width = "#{length}px"
    @$el.append @rotate el, angle
    @

  rotate: (el, angle) ->
    el.style.MozTransform = "rotate(#{angle}deg)"
    el.style.WebkitTransform = "rotate(#{angle}deg)"
    el.style.transform = "rotate(#{angle}deg)"
    el
