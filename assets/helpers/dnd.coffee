# Helpers to transfer data during drag'n'drop
# with a particular concern for Safari bugs
App.Dnd =
  set: (e, type, args...) ->
    data = args.join ','
    e.dataTransfer.setData type, data
    if e.dataTransfer.types == null
      e.dataTransfer.setData 'Text', "#{type},#{data}"

  get: (e) ->
    type = e.dataTransfer.types[0]
    data = e.dataTransfer.getData type
    args = data.split ','
    if type == "text"
      args
    else
      [type, args...]
