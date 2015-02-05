$(document).ready(function(){
  ajaxToDatabase();
  addSwipeEvents($('#all').children());
  var first_div = $('#all').children().eq(0);
  addPhoto(first_div);
  addClassVisited(first_div)
});

function addSwipeEvents(objects) {
  for (i = 0; i<$('#all').children().length; i++ ) {
    $('#all').children().eq(i).on("swipeleft", function() {
      console.log("You just swiped left!")
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
  if (div.attr("class").indexOf("visited") == -1) {
    div.addClass("visited");
  };
};

function ajaxToDatabase() {
  $.ajax({
    type: 'POST',
    url: "/load_locations",
    success: function(data) {
      //add divs to view
      console.log("SUCCESS!!!!!!!!");
      DeleteUnvisited();
      // AppendNew(data);
      console.log(Object.keys(data));
    }
  })
}

function firstUnvisitedIndex() {
  for (i = 0; i < $('#all').children().length; i++ ) {
    var div = $("#all").children().eq(i)
    if (div.attr("class").indexOf("visited") == -1) {
      console.log("i found the first unvisited div at index: "+ i);
      return i
    };
  };

}

function DeleteUnvisited() {
  var index = firstUnvisitedIndex()
  while ( $('#all').children().length > index ) {
    $('#all').children().eq(index).remove();
    console.log("Length after removal is: " + $('#all').children().length )
  };
};

function AppendNew(data) {
  for (i = 0; i<Object.keys(data).length; i++ ) {
    var url = Object.keys(data)[i].toString()
    var visited = allVisitedUrls();
    if ( visited.indexOf( Object.keys(data)[i] ) == -1 ) {
        var div = document.createElement("div")
        div.setAttribute("id", url)
        div.addClass(data[url])
        div.addClass("cupcake")
        $("#all").append(div)
      }
    }
}

function allVisitedUrls() {
  var visited = []
  for (i = 0; i<$('#all').children().length; i++ ) {
    if (div.attr("class").indexOf("visited") != -1) {
      visited.push(div.attr("id"))
    };
  }
  return visited
}
//
//
// function findUnvisitedDiv() {
//   for (i = 0; i<$('#all').children.length; i++ ) {
//     var div = $("#all").children.eq(i)
//     if (div.attr("class").indexOf("visited") != -1) {
//       return div;
//     };
//   };
// };
//
// function deleteAllUnv() {
//   var divs = $("#all").children
//
// }
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
