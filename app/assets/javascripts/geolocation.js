var handleGeolocation = function(position) {
  console.log(position);
  $.post("/geolocations", position, function() { console.log("SUCCESS"); });
};

$(document).on("page:change", function() {
  console.log("We good");

  setInterval(function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(handleGeolocation);
    }
  }, 2000);
});
