// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".
import "./session"
import "./room"
import "./temp_room"
import "./utils"


// Update the online status screen based on connectivity
window.addEventListener('online',  function() {
  $("main").fadeIn("300");
  $(".reconnect-section").fadeOut("300");
});
window.addEventListener('offline',  function() {
  $("main").fadeOut("300");
  $(".reconnect-section").fadeIn("300");
});

// Join button for temp rooms
let join_btn = document.getElementById("join-temp-room-btn");
let join_input = document.getElementById("join-temp-room-input");
$(join_btn).on('click', function() {
  if (join_input.value) {
    window.location.href = window.location.origin + '/temp/' + join_input.value.trim().toLowerCase();
  } else {
    $(join_input).focus()
  }
});