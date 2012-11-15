class App.BoardView extends Backbone.View
  id: 'board-view'

  events:
    'click #add-postit-blue':   'addPostitBlue'
    'click #add-postit-green':  'addPostitGreen'
    'click #add-postit-yellow': 'addPostitYellow'
    'click #add-postit-rose':   'addPostitRose'
    'click #add-line-h': 'addLineH'
    'click #add-line-v': 'addLineV'
    'click #add-line-d': 'addLineD'
    'click .toggle-menu': 'toggleMenu'
    'click .fit-to-content': 'fitToContent'
    'click .move-up':    'moveUp'
    'click .move-down':  'moveDown'
    'click .move-left':  'moveLeft'
    'click .move-right': 'moveRight'
    'click .zoom-in':  'zoomIn'
    'click .zoom-out': 'zoomOut'
    'mousewheel': 'wheel'
    'DOMMouseScroll': 'wheel'

  shortcuts:
    'up':    'moveUp'
    'down':  'moveDown'
    'left':  'moveLeft'
    'right': 'moveRight'

  initialize: ->
    @viewport = new App.Viewport()
    @viewport.on 'change:zoom', @showZoomLevel
    @lines = new App.LinesView
      collection: @model.lines
      viewport: @viewport
      el: @el
    @postits = new App.PostitsView
      collection: @model.postits
      viewport: @viewport
      el: @el
    _.extend @, new Backbone.Shortcuts
    @delegateShortcuts()

  remove: ->
    @postits.remove()
    @lines.remove()
    Backbone.View.prototype.remove.call @

  render: ->
    @$el.html JST.board @model.toJSON()
    @showZoomLevel()
    @lines.render()
    @postits.render()
    types = ['postit', 'corner', 'line', 'handle']
    accepts = ("string:text/#{type}" for type in types).join ' '
    @el.setAttribute 'dropzone', "move #{accepts}"
    @

  addPostit: (color) ->
    @model.postits.create color: color
    false

  addPostitBlue: ->
    @addPostit '3fa1f3'

  addPostitGreen: ->
    @addPostit '7ef45f'

  addPostitYellow: ->
    @addPostit 'f0fa78'

  addPostitRose: ->
    @addPostit 'f878d2'

  addLineH: ->
    @model.lines.createHorizontal()
    false

  addLineV: ->
    @model.lines.createVertical()
    false

  addLineD: ->
    @model.lines.createDiagonal()
    false

  toggleMenu: ->
    @el.querySelector('aside').classList.toggle 'closed'
    false

  fitToContent: ->
    @viewport.fitToContent @model, window.innerWidth, window.innerHeight
    false

  moveUp: ->
    was = @viewport.get 'offset'
    offset = x: was.x, y: was.y - 100
    @viewport.set offset: offset
    false

  moveDown: ->
    was = @viewport.get 'offset'
    offset = x: was.x, y: was.y + 100
    @viewport.set offset: offset
    false

  moveLeft: ->
    was = @viewport.get 'offset'
    offset = x: was.x - 100, y: was.y
    @viewport.set offset: offset
    false

  moveRight: ->
    was = @viewport.get 'offset'
    offset = x: was.x + 100, y: was.y
    @viewport.set offset: offset
    false

  zoomIn: ->
    z = @viewport.get 'zoom'
    z *= 1.3
    @viewport.set zoom: z unless z > 10
    false

  zoomOut: ->
    z = @viewport.get 'zoom'
    z /= 1.3
    @viewport.set zoom: z unless z < 0.1
    false

  wheel: (e) ->
    e = e.originalEvent if e.originalEvent
    d = e.wheelDelta || -e.detail
    if d > 0 then @zoomIn() else @zoomOut()
    false

  showZoomLevel: =>
    level = Math.ceil 100 * @viewport.get 'zoom'
    zoom = (@$ '#zoom-level').text("#{level} %").show()
    clearTimeout @timer if @timer
    @timer = setTimeout ->
      zoom.hide()
    , 2500
