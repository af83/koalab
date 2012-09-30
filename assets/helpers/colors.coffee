App.Colors =
  rgb: (hex) ->
    str = hex.toLowerCase().replace(/^#/, '')
    parseInt (str.slice i, i+2), 16 for i in [0, 2, 4]

  hex: (rgb) ->
    parts = for x in rgb
      ('0' + x.toString 16).slice -2
    '#' + parts.join ''

  mix: (color1, color2, percent) ->
    one = App.Colors.rgb color1
    two = App.Colors.rgb color2
    rgb = for i in [0, 1, 2]
      parseInt percent * one[i] + (1 - percent) * two[i]
    App.Colors.hex rgb
