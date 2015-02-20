$(document).ready(function(){
  console.log("The document is ready!")
  $('#click').click(function(){

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(findPosition, function(errorCode) {
        prepareAddressForm()
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
      prepareAddressForm()
    }
  });

  $('#left-g').click(prevPhoto);
  $('#right-g').click(nextPhoto);

});

function prepareAddressForm() {
  console.log('WHERE ARE YOU????');
  showDiv("#address-section");
  hideDiv("#loading");
  submitAddress();
}

function submitAddress() {
  $("#address_submit").submit(function(e) {
    e.preventDefault();
    var $form = $(this);
    $.ajax({
      url: '/address',
      type: 'POST',
      data: $form.serialize(),
      success: function() {
        console.log("I saved a lat/long from your addresss!! NICE!!")
        console.log("meow!")
        // GET PHOTOS ALREADY IN DB
        hideDiv("#address-section");
        showDiv("#loading");
        ajaxToDatabase();
      },
      error: function() {
        console.log("I didn't save the lat/long from your address. NOT NICE!! :(")
        $("#error-msg").html("Could not interpret that address, please try again.")
      }
    })
  })
}

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

function addSwipesToElem(elem) {
  elem.on("swipeleft", nextPhoto )
  elem.on("swiperight", prevPhoto )
}

function addSwipeEvents( objects ) {
  for (i = 0; i< objects.length; i++ ) {
    addSwipesToElem( objects.eq(i) )
    // addClickToElem( objects.eq(i) )
  }
}

function nextPhoto(next_div) {
  var current_div = $('#all').children().children().parent()
  var div_index = current_div.index()
  var next_div = $('#all').children().eq(div_index + 1)
  if (next_div.length === 0 ) {
    next_div = $('#all').children().eq(0)
  }
  current_div.children().remove()
  hideDetails(current_div)
  addClassVisited(next_div);
  addPhoto(next_div)
  showDetails(next_div)
}

function prevPhoto() {
  var current_div = $('#all').children().children().parent()
  var div_index = current_div.index()
  var prev_div = $('#all').children().eq(div_index - 1)
  current_div.children().remove()
  hideDetails(current_div)
  addClassVisited(prev_div);
  addPhoto(prev_div)
  showDetails(prev_div)
}

function addPhoto(active_div) {
  console.log("lets try to add a photo to " + active_div)
  var photo = document.createElement("img");
  photo.setAttribute("src", active_div.attr('id'));
  photo.setAttribute("class", "link-cursor");
  active_div.append(photo);
}

function showDetails(active_div) {
  var loc_id = active_div.attr('class').replace(/\D/g,'');
  var info_div = $("."+ loc_id);
  info_div.css("display", "block");
};

function hideDetails(active_div) {
  var loc_id = active_div.attr('class').replace(/\D/g,'');
  var info_div = $("."+ loc_id);
  info_div.css("display", "none");
};

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
        $('#details').children().remove();
        AppendNew(data, "old");
        addSwipeEvents($('#all').children());
        handleLoadedPhotos();
      }
      //go to photo container
      console.time("APItimer")
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
    data: {
      offset: "0"
    },
    success: function(data) {
      //add divs to view
      console.log("SUCCESS!!!!!!!!");
      if (data.length === 0) {
        hideDiv("#loading")
        showDiv("#sorry")
      }
      else {
        DeleteUnvisited();
        AppendNew(data, "new");
        addSwipeEvents($('#all').children(".new"))
        if (!already_loaded) {
          handleLoadedPhotos();
        }
        console.timeEnd("APItimer")
        ajaxApiOffset();
      }
    }
  })
}

function ajaxApiOffset() {
  console.log("about to do offset query!")
  $.ajax({
    type: 'POST',
    url: "/load_locations",
    data: {
      offset: "20"
    },
    success: function(data) {
      console.log("offset saving done!!!!")
      DeleteUnvisited();
      AppendNew(data, "newer");
      addSwipeEvents($('#all').children(".newer"))

    }
  })
}

function DeleteUnvisited() {
  $("#all").children().not(".visited").remove()
}

function AppendNew(data, classname) {
  var visited = allVisitedUrls();
  for (i = 0; i < data.length; i++ ) {
    makeShowDivs(data[i])
    var url = data[i].url
    var id = data[i].id
    if ( visited.indexOf( url ) == -1 ) {
      var div = document.createElement("div");
      var class_str = id.toString() + " " + classname
      div.setAttribute("id", url);
      div.setAttribute("class", class_str);
      $("#all").append(div);
    };
  }
}

function calculateFlag(dist) {
  if (dist < 1.5 ) {
    return "&dirflg=w";
  } else {
    return "";
  }
}

function flagPhotos() {
  console.log("let's flag it!")
  // $.ajax({
  //   type: 'POST',
  //   url: "/flag_photo",
  //   data: {
  //     url: url
  //   },
  //   success: function(data) {
  //     console.log("photo got flagged!")
  //     // then remove photo and div
  //
  //   }
  // })
}

function flagButton() {
  var flag = document.createElement("span")
  flag.setAttribute("class", "link-cursor")
  flag.setAttribute("id", "flag-photo")
  flag.innerHTML = "flag this photo"
  $(flag).click(flagPhotos)
  return flag
}

function makeShowDivs(data) {
  if ($('#details').children('.' + data.id).length == 0) {
    var newdiv = document.createElement("div");
    newdiv.innerHTML = "<div class = 'name-div'><hr class = 'hr-thing'><h1 class = 'place-name'>"+ data.name + "</h1></div><hr>" +"<h3 class= 'text-center place-dist'> Within " + data.distance + " miles of you! </h3>" + "<p class = 'place-desc'>" + data.desc + "</p>"

    var yelp_link = makeLink(data.yelp_link, "fa fa-yelp show-icon yg", " yelp")
    var google_link = makeLink(data.google_link, "fa fa-google show-icon yg", " places")
    var hr = document.createElement("hr");

    newdiv.appendChild(yelp_link)
    if (google_link) { newdiv.appendChild(google_link) }
    newdiv.appendChild(hr)

    var go = document.createElement("a");
    var dir_flag = calculateFlag(data.distance)
    go.setAttribute("href", "https://maps.google.com?saddr=" + data.user_lat + "," + data.user_long +"&daddr="+ data.lat+","+data.long+dir_flag);
    go.setAttribute("target", "directions");
    go.setAttribute("class", "fa fa-map-marker show-icon");
    go.setAttribute("id", "go-link");
    newdiv.setAttribute("class", data.id);
    go.innerHTML = "<span class = 'go-text'> go there!</span>";
    newdiv.appendChild(go);
    newdiv.appendChild(flagButton())
    $('#details').append(newdiv)
  }
}

function makeLink(href_text, class_text, text) {
    var link = document.createElement("a")
    link.setAttribute("href", href_text)
    link.setAttribute("target", "directions");
    link.setAttribute("class", class_text);
    link.innerHTML = "<span class = 'link-text'>"+ text+ "</span>";
    return link
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
