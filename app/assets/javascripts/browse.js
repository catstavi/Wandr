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
  addPhoto(next_div)
  showDetails(next_div)
}

function leftArrowHandler() {
  var div_index = $('#all').children().children().parent().index()
  var prev_div = $('#all').children().eq(div_index - 1)
  $('#all').children().children().remove()
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
        $('#details').html("<h3>" + data.name + "</h3> <p>" + data.desc + "</p>")
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
      //if a user hits the wander button a second time, without refreshing the page
      // it removes old divs and finds again (your location may have changed)
      $('#all').children().remove()
      AppendNew(data, "old");
      addSwipeEvents($('#all').children());
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

function firstUnvisitedIndex() {
  var photos = $('#all').children()
  for (i = 0; i < photos.length; i++ ) {
    var div = photos.eq(i)
    if (div.attr("class").indexOf("visited") == -1) {
      return i
    };
  };

}

function DeleteUnvisited() {
  var index = firstUnvisitedIndex()
  while ( $('#all').children().length > index ) {
    $('#all').children().eq(index).remove();
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
  var photos = $('#all').children()
  for (i = 0; i<photos.length; i++ ) {
    var div = photos.eq(i);
    if (div.attr("class").indexOf("visited") != -1) {
      visited.push(div.attr("id"));
    };
  }
  return visited
}

function addPhotoButton() {
  $("#photo-link").css("display", "inline-block");
  console.log("PHOTO BUTTON HAYYYYY");
}
