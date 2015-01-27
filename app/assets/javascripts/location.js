$(document).ready(function(){
  var lat = $('.lat');
  var long = $('.long');

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(findPosition(lat, long))
  }
  else {
    lat.append("Geolocation is not supported by your browser.")
  }
}

function findPosition(position, lat, long) {
  long.innerHTML(position.coords.longitude);
  lat.innerHTML(position.coords.latitude);
}
