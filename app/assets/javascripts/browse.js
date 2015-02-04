$(document).ready(function(){
  addSwipeEvents($('#all').children());
  var first_div = $('#all').children().eq(0);
  addPhoto(first_div);
  addClassVisited(first_div)
});

function addSwipeEvents(objects) {
  for (i = 0; i<$('#all').children().length; i++ ) {
    $('#all').children().eq(i).on("swipeleft", function() {
      console.log("You just swiped left!")
      console.log("i is: " + i)
      $(this).children().remove();
      addClassVisited($(this).next());
      addPhoto( $(this).next() );
    });
    $('#all').children().eq(i).on("swiperight", function() {
      console.log("You just swiped right!")
      $(this).children().remove();
      addPhoto( $(this).prev() );
    });
  }
}

function addPhoto(active_div) {
  console.log("lets try to add a photo to " + active_div)
  var photo = document.createElement("img");
  photo.setAttribute("src", active_div.attr('id'));
  active_div.append(photo);
}

function addClassVisited(div) {
  console.log(div)
  console.log(div.attr("class"))
  if (div.attr("class").indexOf("visited") == -1) {
    div.addClass("visited");
  };
};
// function switchPhoto(active_div, n) {
//   addPhoto(active_div);
//   console.log("added a photo to div: " + n)
//   active_div.on("swipeleft", function() {
//     console.log("You just swiped left!")
//     active_div.children().remove();
//     switchPhoto($('#all').children().eq(n+1), n+1);
  // });
  // active_div.on("swiperight", function() {
  //   console.log("You just swiped right!")
  //   active_div.children().remove();
  //   addPhoto($('#all').children().eq(n-1));
  // });
  // active_div.click( function() {
  //   active_div.children().remove()
  //   switchPhoto($('#all').children().eq(n-1), n-1)
  // });
// };
