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
    'click .zoom-in':  'zoomIn'
    'click .zoom-out': 'zoomOut'
    'click .move-up':    'moveUp'
    'click .move-down':  'moveDown'
    'click .move-left':  'moveLeft'
    'click .move-right': 'moveRight'

  initialize: ->
    @viewport = new App.Viewport()
    @lines = new App.LinesView collection: @model.lines, viewport: @viewport
    @postits = new App.PostitsView collection: @model.postits, viewport: @viewport
    @model.lines.fetch()
    @model.postits.fetch()

  render: ->
    @$el.html JST.board @model.toJSON()
    @$el.append @lines.render().el
    @$el.append @postits.render().el
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

  zoomIn: ->
    z = @viewport.get 'zoom'
    z *= 1.4
    @viewport.set zoom: z unless z > 3
    false

  zoomOut: ->
    z = @viewport.get 'zoom'
    z /= 1.4
    @viewport.set zoom: z unless z < 0.3
    false

  moveUp: ->
    offset = @viewport.get 'offset'
    offset.y += 100
    @viewport.set offset: offset
    # FIXME it seeems backbone don't trigger the 'change' event here
    # Is it a bug? I should try the head version
    @viewport.trigger 'change'
    false

  moveDown: ->
    offset = @viewport.get 'offset'
    offset.y -= 100
    @viewport.set offset: offset
    @viewport.trigger 'change'
    false

  moveLeft: ->
    offset = @viewport.get 'offset'
    offset.x += 100
    @viewport.set offset: offset
    @viewport.trigger 'change'
    false

  moveRight: ->
    offset = @viewport.get 'offset'
    offset.x -= 100
    @viewport.set offset: offset
    @viewport.trigger 'change'
    false
