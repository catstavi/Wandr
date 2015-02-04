$(document).ready(function(){
  var n = 1
  var active_div = $('#all').children().eq(n);
  switchPhoto(active_div, n);
});

function switchPhoto(active_div, n) {
  n +=1
  var photo = document.createElement("img");
  photo.setAttribute("src", active_div.attr('id'));
  active_div.append(photo);
  active_div.click(function() {
    active_div.children().remove()
    switchPhoto($('#all').children().eq(n), n)
  })
};
