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
  var url = "/yelpit"
  $.ajax({
    type: 'POST',
    url: url,
    data: {
      'latitude': position.coords.latitude,
      'longitude': position.coords.longitude,
    },
    success: function (data) {
      if (data == null) {
        $('body').css("background", "red");
        }
      else {
        console.log(data)
        $('body').css("background", "blue");
      }
    }
  });
};
