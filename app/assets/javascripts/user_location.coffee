handleLocation = (position) ->
  location_path = $('#create-user-location-path').html()
  $.post location_path, position

getLocation = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition handleLocation

handler = ->
  if $('#user-location-valid-until').length > 0
    starts_at = 1000 * (parseInt $('#user-location-valid-until').html())
    interval  = 1000 * (parseInt $('#user-location-valid-for').html() / 2)
    
    setTimeout (->
      getLocation()
      setInterval (->
        getLocation()
      ), interval
    ), starts_at

$(document).on "ready page:load", handler
