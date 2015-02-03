$(document).ready(function(){
  console.log("lets go!")
  var active_div = $('#all').children().first();
  var photo = document.createElement("img");
  photo.setAttribute("src", active_div.attr('id'));
  active_div.appendChild(photo);
})
