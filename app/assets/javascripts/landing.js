$(document).ready(function(){
  $('.click').click(function(){
    var msg = $('.msg')

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(findPosition)
    }
    else {
      msg.append("Geolocation is not supported by your browser.")
    }
  });
});

function findPosition(position) {
  $('body').css("background", "orange");
  var url = '/sessions'
  $.ajax({
    type: 'POST',
    url: url,
    data: {
      'latitude': position.coords.latitude,
      'longitude': position.coords.longitude,
    },
    success: function (data) {
      $('body').css("background", "blue");
      // if (data == null) {
      //   $('body').css("background", "red");
      //   }
      // else {
      //   console.log(data)
      //   $('body').css("background", "blue");
      // }
    }
  });
};
