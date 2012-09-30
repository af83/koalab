class App.Postit extends Backbone.Model
  defaults: ->
    title: App.Postit.defaultTitle
    color: "ccc"
    coords:
      x: 50 + Math.floor(Math.random() * 100)
      y: 50 + Math.floor(Math.random() * 100)
    size:
      w: 150
      h: 150
    angle: (Math.random() * 15).toFixed(1) - 7

  move: (dx, dy) ->
    was = @get 'coords'
    @set coords:
      x: was.x + dx
      y: was.y + dy
    @save()

  # We project the post-it (a square) and [a,b] on D,
  # the straight line perpendicular to (a,c) that goes through a,
  # and we return true if the two projected segments intersect
  canBeProjectedOn: (a, b, c) ->
    coords = @get 'coords'
    size   = @get 'size'
    if a.x == c.x       # (a,c) is vertical => D is horizontal
      pa = a.x
      pb = b.x
      p1 = coords.x
      p2 = coords.x + size.w
    else if a.y == c.y  # (a,c) is horizontal => D is vertical
      pa = a.y
      pb = b.y
      p1 = coords.y
      p2 = coords.y + size.h
    else                # D is described by y = dx + e
      d = (a.x - c.x) / (c.y - a.y)
      e = a.y - d * a.x
      # We chose the 2 interesting corners of the post-it depending
      # if the line if ascending or descending
      if d > 0
        first  = x: coords.x, y: coords.y
        second = x: coords.x + size.w, y: coords.y + size.h
      else
        first  = x: coords.x, y: coords.y + size.h
        second = x: coords.x + size.w, y: coords.y
      # The straight line perpendicular to D that passes on first is:
      # y = (-1/d) * x + first{y} + first{x} / d
      # So the projection of first on D has for x coordinate:
      p1 = (first.y + first.x/d - e) / (d + 1/d)
      # Same thing for second:
      p2 = (second.y + second.x/d - e) / (d + 1/d)
      [x1, x2] = [x2, x1] if x1 > x2
      # By the same reasoning, we can find the x coordinates of b projection
      pb = (b.y + b.x/d - e ) / (d + 1/d)
      # And the projection of a on D is obviously a
      pa = a.x
    [pa, pb] = [pb, pa] if pa > pb
    [p1, p2] = [p2, p1] if p1 > p2
    p2 > pa and p1 < pb

  # Does the post-it has an intersection with the given parallelogram area?
  # The parallelogram area is described by its 4 corners: a, b, c and d
  intersects: (a, b, c, d) ->
    # Avoid an obtuse angle on a
    scalar = (b.x - a.x) * (c.x - a.x) + (b.y - a.y) * (c.y - a.y)
    # If it's the case, we swap a with b, and c with d
    [a, b, c, d] = [b, a, d, c] if scalar < 0
    @canBeProjectedOn(a, d, b) and @canBeProjectedOn(a, d, c)

App.Postit.defaultTitle = "New post-it"
