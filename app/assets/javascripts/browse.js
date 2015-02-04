$(document).ready(function(){
  var active_div = $('#all').children().eq(1);
  switchPhoto(active_div, 1);
});

function switchPhoto(active_div, n) {
  var photo = document.createElement("img");
  photo.setAttribute("src", active_div.attr('id'));
  active_div.append(photo);
  active_div.on("swipeleft", function() {
    active_div.children().remove()
    switchPhoto($('#all').children().eq(n+1), n+1)
  });
  active_div.on("swiperight", function() {
    active_div.children().remove()
    switchPhoto($('#all').children().eq(n-1), n-1)
  });
};
