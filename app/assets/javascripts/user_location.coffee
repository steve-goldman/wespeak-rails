handleLocation = (position) ->
  location_path = $('#create-user-location-path').html()
  $.post location_path, position
  # re-set the timer
  console.log 'setting next timer'
  setTimeout getLocation, 1000 * (parseInt $('#user-location-valid-for').html()) / 2

getLocation = ->
  # only do this if the browser supports and user allows
  if navigator.geolocation
    $('#user-location-timer-set').html 'true'
    # defer if the page is not visible
    if document.hidden
      console.log 'timer went off but page not visible'
      $('#user-location-timer-set').html 'false'
    # otherwise do the request
    else
      console.log 'getting position'
      navigator.geolocation.getCurrentPosition handleLocation

visibilityChanged = ->
  if !document.hidden && $('#user-location-timer-set').html() == 'false'
    console.log 'calling getLocation because page visible and no timer'
    getLocation()
    

handler = ->
  # only do this for pages that use position info
  if $('#user-location-valid-until').length > 0
    # track visibility changes so that when the page comes into focus
    # we can decide if we need to immediately get the position
    document.addEventListener 'visibilitychange', visibilityChanged
    # prime the loop
    console.log 'setting initial timer'
    setTimeout getLocation, 1000 * (parseInt $('#user-location-valid-until').html())

$(document).on "ready page:load", handler
