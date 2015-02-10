$(document).ready(function(){
  // $('#learn').click(function(){
  //   console.log("clicked!")
  //
  //   $('#howitworks').animate({
  //     top: "0"}, 5000, function() {
  //       console.log("howitworks shown")
  //     }
  //   });
  //
  //   $('#landing').animate({
  //     top: "-100"}, 5000, function() {
  //     console.log("landing hid")
  //     }
  //   });
  //
  // });


  //LEARN MORE LINK
    $( "#learn").click(function() {
      $( "#landing" ).animate({
        top: "-100%"
      }, 1000, function() {
        // Animation complete.
      });


      $( "#howitworks" ).animate({
        top: "0"
      }, 1000, function() {
        // Animation complete.
      });
    });

//NAVBAR ABOUT LINK
    $( "#how").click(function() {
      console.log("clickity click")
      $( "#landing" ).animate({
        top: "-100%"
      }, 1000, function() {
        // Animation complete.
      });


      $( "#howitworks" ).animate({
        top: "0"
      }, 1000, function() {
        // Animation complete.
      });
    });

//NAVBAR LANDING LINK
    $( "#land-link").click(function() {
      console.log("clickity click")
      $( "#landing" ).animate({
        top: "0"
      }, 1000, function() {
        // Animation complete.
      });

      $( "#howitworks" ).animate({
        top: "-100%"
      }, 1000, function() {
        // Animation complete.
      });

      $( "#learn" ).animate({
        top: "-100%"
      }, 1000, function() {
        // Animation complete.
      });

      $( "#photo-slides" ).animate({
        top: "-100%"
      }, 1000, function() {
        // Animation complete.
      });

      $( "#team" ).animate({
        top: "-100%"
      }, 1000, function() {
        // Animation complete.
      });
    });

//NAVBAR about link
  $( "#how-link").click(function() {
    console.log("clickity click")
    $( "#landing" ).animate({
      top: "-100%"
    }, 1000, function() {
      // Animation complete.
    });

    $( "#howitworks" ).animate({
      top: "0"
    }, 1000, function() {
      // Animation complete.
    });

    $( "#learn" ).animate({
      top: "-100%"
    }, 1000, function() {
      // Animation complete.
    });

    $( "#photo-slides" ).animate({
      top: "-100%"
    }, 1000, function() {
      // Animation complete.
    });

    $( "#team" ).animate({
      top: "-100%"
    }, 1000, function() {
      // Animation complete.
    });
  });

});
