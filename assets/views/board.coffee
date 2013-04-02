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
    'mousewheel':     'wheel'
    'DOMMouseScroll': 'wheel'
    'touchstart':  'touchstart'
    'touchcancel': 'touchcancel'
    'touchmove':   'touchmove'
    'touchend':    'touchend'

  shortcuts:
    'up':      'moveUp'
    'down':    'moveDown'
    'left':    'moveLeft'
    'right':   'moveRight'

    # Zoom in/out with keyboard too (note: KeyMaster </3 Firefox)
    '-':       'zoomOut'
    'shift+=': 'zoomIn'
    '=':       'zoomDefault'

    # Even Facebook uses thoses shortcuts now:
    'k':       'moveUp'
    'j':       'moveDown'
    'h':       'moveLeft'
    'l':       'moveRight'

  initialize: ->
    @viewport = new App.Viewport()
    @viewport.on 'change:zoom', @showZoomLevel
    @trash = new App.TrashView
      model: @model
      el: @el
    @lines = new App.LinesView
      collection: @model.lines
      viewport: @viewport
      el: @el
    @postits = new App.PostitsView
      collection: @model.postits
      viewport: @viewport
      el: @el
    @delegateShortcuts()

  remove: ->
    @trash.remove()
    @postits.remove()
    @lines.remove()
    Backbone.View.prototype.remove.call @

  render: ->
    @$el.html JST.board @model.toJSON()
    @showZoomLevel()
    @trash.render()
    @lines.render()
    @postits.render()
    App.Dnd.install @el, ['postit', 'corner', 'line', 'handle']
    @

  addPostit: (color) ->
    coords = @viewport.fromScreen
      x: 50 + Math.floor(Math.random() * 100)
      y: 50 + Math.floor(Math.random() * 100)
    @model.postits.create color: color, coords: coords
    false

  addPostitBlue: ->
    @addPostit App.Postit.colors.blue

  addPostitGreen: ->
    @addPostit App.Postit.colors.green

  addPostitYellow: ->
    @addPostit App.Postit.colors.yellow

  addPostitRose: ->
    @addPostit App.Postit.colors.rose

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

  moveUp: (e) ->
    was = @viewport.get 'offset'
    offset = x: was.x, y: was.y - 100
    @viewport.set offset: offset
    false

  moveDown: (e) ->
    was = @viewport.get 'offset'
    offset = x: was.x, y: was.y + 100
    @viewport.set offset: offset
    false

  moveLeft: (e) ->
    was = @viewport.get 'offset'
    offset = x: was.x - 100, y: was.y
    @viewport.set offset: offset
    false

  moveRight: (e) ->
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

  zoomDefault: ->
    @viewport.set zoom: 1
    false

  wheel: (e) ->
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

  touchstart: (e) =>
    return if @touch
    return if e.touches.length != e.changedTouches.length  # Other touches
    touch = e.changedTouches[0]
    offset = @viewport.get 'offset'
    @touch =
      x: touch.pageX + offset.x
      y: touch.pageY + offset.y
      id: touch.identifier
    true

  touchmove: (e) =>
    return unless @touch
    touch = App.Touch.find e.changedTouches, @touch.id
    if touch
      @viewport.set offset:
        x: @touch.x - touch.pageX
        y: @touch.y - touch.pageY
    true

  touchcancel: =>
    @touch = null
    true

  touchend: =>
    @touch = null
    true

App.BoardView.prototype.delegateShortcuts =
  Backbone.Shortcuts.prototype.delegateShortcuts
