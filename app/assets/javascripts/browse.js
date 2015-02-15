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
    // addClickToElem( objects.eq(i) )
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
  showDetails(next_div)
}

function leftArrowHandler() {
  var div_index = $('#all').children().children().parent().index()
  var prev_div = $('#all').children().eq(div_index - 1)
  $('#all').children().children().remove()
  addClassVisited(prev_div);
  addPhoto(prev_div)
  showDetails(prev_div)
}

function showDetails(current_photo) {
    $.ajax({
      type: 'POST',
      url: 'locations/show',
      data: {
        id: current_photo.attr('class').replace(/\D/g,'')
      },
      success: function(data) {
        console.log(data.name)
        $('#details').html("<h3>" + data.name + "</h3> <p>" + data.desc + "</p>");
        var go = document.createElement("a");
        go.setAttribute("href", "https://maps.google.com?saddr=" + data.user_lat + "," + data.user_long +"&daddr="+ data.lat+","+data.long+"&dirflg=w");

        // go.setAttribute("href", "https://www.google.com/maps/dir/" + data.user_lat + "," + data.user_long +"/"+ data.lat+","+data.long+"/dirflg=w");
        // go.setAttribute("href", "https://maps.google.com?saddr=47.5928688,-122.3171234&daddr=47.588442,-122.3202149&dirflg=w");
        go.setAttribute("target", "directions");
        // "https://www.google.com/maps/dir/Current+Location/43.12345,-76.12345"
        $(go).html("go there");
        $('#details').append(go);
      }
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
  showDetails(next_div);
}

function swipeRightHandler() {
  console.log("You just swiped right!")
  $(this).children().remove();
  addClassVisited(prev_div);
  addPhoto( $(this).prev() );
  showDetails( $(this).prev() );
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
      var db_loaded = data.length != 0
      //if a user hits the wander button a second time, without refreshing the page
      // it removes old divs and finds again (your location may have changed)
      if (db_loaded) {
        $('#all').children().remove();
        AppendNew(data, "old");
        addSwipeEvents($('#all').children());
        handleLoadedPhotos();
      }
      //go to photo container
      ajaxTriggerApiCalls(db_loaded);
    },
    error: function() {
      console.log("ERRORERRORERROR")
    }
  })
};

function handleLoadedPhotos() {
  var first_div = $('#all').children().eq(0);
  addPhoto(first_div);
  showDetails(first_div)
  addClassVisited(first_div)
  hideDiv("#loading")
  showDiv("#photo-slides")
  addPhotoButton()
}

function ajaxTriggerApiCalls(already_loaded) {
  $.ajax({
    type: 'POST',
    url: "/load_locations",
    success: function(data) {
      //add divs to view
      console.log("SUCCESS!!!!!!!!");
      DeleteUnvisited();
      AppendNew(data, "new");
      addSwipeEvents($('#all').children(".new"))
      if (!already_loaded) {
        handleLoadedPhotos();
      }
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
}
