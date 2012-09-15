class App.LineView extends Backbone.View
  className: 'line'

  initialize: ->
    @model.on 'change', @render

  render: =>
    @el.style.left = "#{@model.get 'x1'}px"
    @el.style.top  = "#{@model.get 'y1'}px"
    @el.style.width = "#{Math.floor @model.length()}px"
    @rotate()
    @

  rotate: ->
    angle = @model.angle()
    @el.style.MozTransform = "rotate(#{angle}deg)"
    @el.style.WebkitTransform = "rotate(#{angle}deg)"
    @el.style.transform = "rotate(#{angle}deg)"
    @
