ready = ->
  tinymce.remove()

$(document).on('page:receive', ready)
