# Helpers to transfer data during drag'n'drop
# with a particular concern for Safari bugs
App.Dnd =
  install: (el, types) ->
    accepts = ("string:text/koalab-#{type}" for type in types).join ' '
    el.setAttribute 'dropzone', "move #{accepts}"

  set: (e, type, args...) ->
    data = args.join ','
    e.dataTransfer.setData type, data
    if e.dataTransfer.types == null
      e.dataTransfer.setData "Text", "#{type},#{data}"

  get: (e) ->
    type = 'Text'
    for t in e.dataTransfer.types
      type = t if t.indexOf('koalab') != -1
    data = e.dataTransfer.getData type
    return [] unless data
    args = data.split ','
    if type == "text"
      args
    else
      [type, args...]
