handler = ->
    $('[data-toggle="popover"]').popover()
    $('[data-toggle="popover"]').click (e) ->
      e.preventDefault()

$(document).on "ready page:load", handler
