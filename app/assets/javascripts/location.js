$(document).ready(function(){
  var lat = $('.lat');
  var long = $('.long');

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(findPosition)
  }
  else {
    lat.append("Geolocation is not supported by your browser.")
  }
});

function findPosition(position) {
  var lat = $('.lat');
  var long = $('.long');

  long.append(position.coords.longitude);
  lat.append(position.coords.latitude);
};
