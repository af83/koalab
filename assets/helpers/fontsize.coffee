App.FontSize =
  initialize: ->
    clone = document.createElement 'p'
    clone.style.visibility = 'hidden'
    inner = document.createElement 'span'
    clone.appendChild inner
    App.FontSize.inner = inner
    App.FontSize.clone = clone

  adjust: (element, width, height) ->
    # Prepare
    clone = App.FontSize.clone
    inner = App.FontSize.inner
    clone.style.width  =  "#{width}px"
    clone.style.height = "#{height}px"
    inner.textContent = element.textContent
    document.body.appendChild clone
    # Bisect to find the right font size
    [low, high] = [6, 80]
    while low < high
      size = Math.ceil (low + high) / 2
      inner.style.fontSize = "#{size}px"
      if inner.offsetWidth > width or inner.offsetHeight > height
        high = size - 1
      else
        low = size
    # Clean
    document.body.removeChild clone
    # Apply the font size
    element.style.fontSize = "#{low}px"
    low

$ App.FontSize.initialize
