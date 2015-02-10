$(document).ready(function(){
  console.log("The document is ready!")
  $('#click').click(function(){
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
  var url = '/sessions'
  $.ajax({
    type: 'POST',
    url: url,
    data: {
      'latitude': position.coords.latitude,
      'longitude': position.coords.longitude,
    },
    success: function (data) {
      //show loading gif here
      console.log("meow!")
      // GET PHOTOS ALREADY IN DB
      ajaxToDatabase();
      ajaxTriggerApiCalls();
      // addSwipeEvents($('#all').children());
      // var first_div = $('#all').children().eq(0);
      // console.log(first_div)
      // addPhoto(first_div);
      // addClassVisited(first_div)
    }
  });
};


function addSwipeEvents( objects ) {
  for (i = 0; i< objects.length; i++ ) {
    addSwipesToElem( objects.eq(i) )
    addClickToElem( objects.eq(i) )
  }
}

function addClickToElem(elem) {
  elem.click( function() {
    $('#details').show();
    var clicked = $(this)
    $.ajax({
      type: 'POST',
      url: 'locations/show',
      data: {
        id: clicked.attr('class').replace(/\D/g,'')
      },
      success: function(data) {
        console.log(data.name)
        $('#details').html("<h3>" + data.name + "</h3> <p>" + data.desc + "</p>")
      }
    })
  })
}

function addSwipesToElem(elem) {
  elem.on("swipeleft", swipeLeftHandler )
  elem.on("swiperight", swipeRightHandler )
}

function swipeLeftHandler() {
  console.log("You just swiped left!")
  $(this).children().remove();
  addClassVisited($(this).next());
  addPhoto( $(this).next() );
  $('#details').hide();
}

function swipeRightHandler() {
  console.log("You just swiped right!")
  $(this).children().remove();
  addPhoto( $(this).prev() );
  $('#details').hide();
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
  console.log("hey girl")
  $.ajax({
    type: 'POST',
    url: '/get_db_photos',
    success: function(data) {
      console.log("I defeated the mighty Ajax!");
      console.log(data);
      AppendNew(data, "old");
      addSwipeEvents($('#all').children());
      var first_div = $('#all').children().eq(0);
      console.log(first_div)
      addPhoto(first_div);
      addClassVisited(first_div)
      //go to photo container
    },
    error: function() {
      console.log("ERRORERRORERROR")
    }
  })
};

function ajaxTriggerApiCalls() {
  // console.log("meow")
  $.ajax({
    type: 'POST',
    url: "/load_locations",
    success: function(data) {
      //add divs to view
      console.log("SUCCESS!!!!!!!!");
      console.log(data)
      DeleteUnvisited();
      AppendNew(data, "new");
      addSwipeEvents($('#all').children(".new"))
      console.log(Object.keys(data));
    }
  })
}

function firstUnvisitedIndex() {
  for (i = 0; i < $('#all').children().length; i++ ) {
    var div = $("#all").children().eq(i)
    if (div.attr("class").indexOf("visited") == -1) {
      // console.log("i found the first unvisited div at index: "+ i);
      return i
    };
  };

}

function DeleteUnvisited() {
  var index = firstUnvisitedIndex()
  while ( $('#all').children().length > index ) {
    $('#all').children().eq(index).remove();
    // console.log("Length after removal is: " + $('#all').children().length )
  };
};

function AppendNew(data, classname) {
  for (i = 0; i<data.length; i++ ) {
    var url = Object.keys(data[i]).toString();
    var location_id = data[i][url]
    var visited = allVisitedUrls();
    if ( visited.indexOf( url ) == -1 ) {
        var div = document.createElement("div");
        div.setAttribute("id", url);
        $("#all").append(div);
        div = $("#all").children().last();
        div.addClass(location_id.toString());
        div.addClass(classname);
      };
    }
}

function allVisitedUrls() {
  var visited = []
  for (i = 0; i<$('#all').children().length; i++ ) {
    var div = $('#all').children().eq(i);
    if (div.attr("class").indexOf("visited") != -1) {
      visited.push(div.attr("id"));
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
