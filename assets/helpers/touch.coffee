# Helpers for (multi-)touch events
App.Touch =

  # Seems like chrome don't implement identifiedTouch
  find: (touches, id) ->
    if touches.identifiedTouch
      touches.identifiedTouch id
    else
      return t for t in touches when t.identifier == id
