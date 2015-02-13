$(document).ready(function(){
  console.log("The document is ready!")
  $('#click').click(function(){

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(findPosition, function(errorCode) {
          console.log('WHERE ARE YOU????');
          // offer address form here
      })
      // shows the loading gif
      hideDiv("#landing")
      console.log("I'm about to show the loading animation")
      showDiv("#loading");
    }
    else {
      // offer address form here?
      console.log("HEY! Geolocation is not supported by your browser.")
    }
  });

  $('#left-g').click(leftArrowHandler);
  $('#right-g').click(rightArrowHandler);

});

function findPosition(position) {
  $.ajax({
    type: 'POST',
    url: '/sessions',
    data: {
      'latitude': position.coords.latitude,
      'longitude': position.coords.longitude,
    },
    success: function (data) {
      console.log("meow!")
      // GET PHOTOS ALREADY IN DB
      ajaxToDatabase();
    },
    error: function() {
      console.log("IM AN ERROR YOU GUYS!!!!")
    }
  });
};

function addSwipeEvents( objects ) {
  for (i = 0; i< objects.length; i++ ) {
    addSwipesToElem( objects.eq(i) )
    addClickToElem( objects.eq(i) )
  }
}

function rightArrowHandler() {
  var div_index = $('#all').children().children().parent().index()
  var next_div = $('#all').children().eq(div_index + 1)
  if (next_div.length === 0 ) {
    next_div = $('#all').children().eq(0)
  }
  $('#all').children().children().remove()
  addClassVisited(next_div);
  addPhoto(next_div)
}

function leftArrowHandler() {
  var div_index = $('#all').children().children().parent().index()
  var prev_div = $('#all').children().eq(div_index - 1)
  $('#all').children().children().remove()
  addClassVisited(prev_div);
  addPhoto(prev_div)
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
  next_div = $(this).next()
  if (next_div.length === 0 ) {
    next_div = $('#all').children().eq(0)
  }
  addClassVisited(next_div);
  addPhoto( next_div );
  $('#details').hide();
}

function swipeRightHandler() {
  console.log("You just swiped right!")
  $(this).children().remove();
  addClassVisited(prev_div);
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
      //if a user hits the wander button a second time, without refreshing the page
      // it removes old divs and finds again (your location may have changed)
      $('#all').children().remove();
      console.log("children removed");
      AppendNew(data, "old");
      console.log("appended new");
      addSwipeEvents($('#all').children());
      console.log("swipe events added");
      var first_div = $('#all').children().eq(0);
      addPhoto(first_div);
      addClassVisited(first_div)
      //go to photo container
      hideDiv("#loading")
      showDiv("#photo-slides")
      addPhotoButton()
      ajaxTriggerApiCalls();
    },
    error: function() {
      console.log("ERRORERRORERROR")
    }
  })
};

function ajaxTriggerApiCalls() {
  $.ajax({
    type: 'POST',
    url: "/load_locations",
    success: function(data) {
      //add divs to view
      console.log("SUCCESS!!!!!!!!");
      DeleteUnvisited();
      AppendNew(data, "new");
      addSwipeEvents($('#all').children(".new"))
    }
  })
}

function DeleteUnvisited() {
  $("#all").children().not(".visited").remove()
}

function AppendNew(data, classname) {
  var visited = allVisitedUrls();
  for (i = 0; i < data.length; i++ ) {
    var url = Object.keys(data[i]).toString();
    var location_id = data[i][url]
    if ( visited.indexOf( url ) == -1 ) {
      var div = document.createElement("div");
      var class_str = location_id.toString() + " " + classname
      div.setAttribute("id", url);
      div.setAttribute("class", class_str);
      $("#all").append(div);
    };
  }
}

function allVisitedUrls() {
  var visited = []
  var photos = $('#all').children(".visited")
  for (i = 0; i<photos.length; i++ ) {
    var div = photos.eq(i);
    visited.push(div.attr("id"));
  }
  return visited
}

function addPhotoButton() {
  $("#photo-link").css("display", "inline-block");
  console.log("PHOTO BUTTON HAYYYYY");
}
