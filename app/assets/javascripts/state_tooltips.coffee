handler = ->
    $('[data-toggle="tooltip"]').tooltip()

$(document).on "ready page:load", handler
