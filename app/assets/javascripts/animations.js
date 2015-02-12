$(document).ready(function(){

  //LINK ANIMATIONS
  $( "#learn").click(function() {
    hideDiv("#landing");
    showDiv("#howitworks");
  });

  $("#land-link").click(function() {
    hideDiv("#howitworks");
    hideDiv("#loading");
    hideDiv("#photo-slides");
    hideDiv("#team");
    showDiv("#landing");
  });

  $("#how-link").click(function() {
    hideDiv("#landing");
    hideDiv("#loading");
    hideDiv("#photo-slides");
    hideDiv("#team");
    showDiv("#howitworks");
  });

  $("#team-link").click(function() {
    hideDiv("#landing");
    hideDiv("#loading");
    hideDiv("#photo-slides");
    hideDiv("#howitworks");
    showDiv("#team");
  });

  $("#photo-link").click(function() {
    hideDiv("#howitworks");
    hideDiv("#loading");
    hideDiv("#landing");
    hideDiv("#team");
    showDiv("#photo-slides");
  });
});


function showDiv(div_id) {
  $( div_id ).animate({
    top: "0"
  }, 1000, function() {
    // Animation complete.
    }
  )}


function hideDiv(div_id) {
  $( div_id ).animate({
    top: "-100%"
  }, 1000, function() {
    // Animation complete.
  });
}
