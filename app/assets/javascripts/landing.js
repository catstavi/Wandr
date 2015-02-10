// $(document).ready(function(){
//   $('.click').click(function(){
//     var msg = $('.msg')
//
//     if (navigator.geolocation) {
//       navigator.geolocation.getCurrentPosition(findPosition)
//     }
//     else {
//       msg.append("Geolocation is not supported by your browser.")
//     }
//   });
// });
//
// function findPosition(position) {
//   $('body').css("background", "orange");
//   var url = '/sessions'
//   $.ajax({
//     type: 'POST',
//     url: url,
//     data: {
//       'latitude': position.coords.latitude,
//       'longitude': position.coords.longitude,
//     },
//     success: function (data) {
//       $('body').css("background", "blue");
//         if (window.location.pathname == "/browse") {
//           ajaxToDatabase();
//           addSwipeEvents($('#all').children());
//           var first_div = $('#all').children().eq(0);
//           addPhoto(first_div);
//           addClassVisited(first_div)
//         }
//     }
//   });
// };
