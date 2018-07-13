// Modal functions
$( "#online-users-button" ).click(function() {
  $('#onlineUsersModal').modal('toggle');
});

$( "#add-sticky-reflection-button" ).click(function() {
  $('#addStickyReflection').modal('toggle');
});

$( "#add-sticky-happiness-button" ).click(function() {
  $('#addStickyHappiness').modal('toggle');
});

// Tab functions
$("#nav-reflection > .nav-link").click(function() {
  $("#reflection").addClass("active show");
  $("#happiness").removeClass("active show");
});

$("#nav-happiness > .nav-link").click(function() {
  $("#happiness").addClass("active show");
  $("#reflection").removeClass("active show");
});