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
import {Presence} from "phoenix"
import socket from "./socket"

if (window.location.pathname.split("/")[1] === "temp") {
  let input_url = document.getElementById("temp_url")
  let copy_url = document.getElementById("copy_url")
  input_url.value = window.location.href;
  $(input_url).hide()
  copy_url.addEventListener('click', function (event) {
    $(input_url).show()
    input_url.select();
    document.execCommand('copy');
    $(input_url).hide()
  })


  console.log("TEMP_ROOMS")

const DAY_OPTIONS = ["option-m", "option-t", "option-w", "option-th", "option-f"];
const WEEK_OPTIONS = ["option-w1", "option-w2"];

let presences = {}
let onlineUsers = document.getElementById("online-users")

// Create list of users
let listUsers = (user) => {
  return {
    user: user
  }
}
// Render list of users
let renderUsers = (presences) => {
  onlineUsers.innerHTML = Presence.list(presences, listUsers)
  .map(presence => `
    <li>${presence.user}</li>`).join("")
}

// Find correct Ul from payload
function getCorrectUl(payload) {
  var {week, day} = payload;
  return $(document.getElementById(week + "-" + day)).find("ul")[0];
}

// Get id from option id
function getCorrectId(str) {
  return str.split("-")[1];
}

function handleChangeElement(el, id) {
  $(el.currentTarget).children("input").prop("checked", true);
  $(document.getElementById(id)).find("input").parent().removeClass("active");
  $(document.getElementById(id)).find("input:checked").parent().addClass("active");
  console.log($(document.getElementById(id)).find("input:checked")[0])
  return $(document.getElementById(id)).find("input:checked")[0];
}

// Add event listeners to week buttons
$("#week-options-radio-reflection").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", (el) => {
    week_reflection = handleChangeElement(el, "week-options-radio-reflection") 
  });
});

// Add event listeners to day buttons
$("#day-options-radio-reflection").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", (el) => {
    day_reflection = handleChangeElement(el, "day-options-radio-reflection")
  });
});

// Add event listeners to week buttons
$("#week-options-radio-happiness").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", (el) => {
    week_happiness = handleChangeElement(el, "week-options-radio-happiness") 
  });
});

// Add event listeners to day buttons
$("#day-options-radio-happiness").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", (el) => {
    day_happiness = handleChangeElement(el, "day-options-radio-happiness")
  });
});

//Connect to chat 'room'
let room = $('.reflection-page').data("room") || "lobby";
var channel = socket.channel('temp_room:' + room, {});        // connect to chat "temp_room"

  // Sync state
  channel.on('presence_state', state => {
    presences = Presence.syncState(presences, state)
    console.log(presences)
    renderUsers(presences)
  });
  // Sync diff
  channel.on('presence_diff', diff => {
    presences = Presence.syncDiff(presences, diff)
    console.log(presences)
    renderUsers(presences)
  });

channel.on('shout', function (payload) {                      // listen to shout event
  if (payload.week !== "h1") {
    var li = $(document.createElement("li"))
      .addClass("col-6 col-md-6 col-lg-12 col-xl-6 zoom-in")[0]         // create new list item
    var name = payload.name || 'anon';                          // get name from payload or use default
    li.innerHTML = `<b>${name}</b>:<br/>${payload.message}`;    // set li contents
    getCorrectUl(payload).appendChild(li);                      // append to list

  } else if (payload.week === "h1"){
    var li = $(document.createElement("li"))
      .addClass("happiness-num col-md-6 offset-md-3 fade slide-in")[0]         // create new list item
    var name = payload.name || 'anon';                          // get name from payload or use default
    li.innerHTML = `<p class="happiness-name">${name}</p>${payload.day}`;    // set li contents
    getCorrectUl(payload).appendChild(li);                      // append to list
  }
                        
});

channel.join()                                               // join channel
.receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

var temp_room_id_reflection = $('.reflection-page').data("room");
var name_reflection = document.getElementById('name-reflection');                   // name of message sender
var msg_reflection = document.getElementById('msg-reflection');                     // message input field
var add_sticky_btn_reflection = document.getElementById('post-sticky-reflection');
var week_reflection = $(document.getElementById('week-options-radio-reflection'))
  .children("label.active").find("input")[0]
var day_reflection = $(document.getElementById('day-options-radio-reflection'))
  .children("label.active").find("input")[0]

var temp_room_id_happiness = $('.reflection-page').data("room");
var name_happiness = document.getElementById('name-happiness');                   // name of message sender
var msg_happiness = document.getElementById('msg-happiness');                     // message input field
var add_sticky_btn_happiness = document.getElementById('post-sticky-happiness');   // add sticky button
var week_happiness = $(document.getElementById('week-options-radio-happiness'))
  .children("label.active").find("input")[0]
var day_happiness = $(document.getElementById('day-options-radio-happiness'))
  .children("label.active").find("input")[0]

  // Listen for click  keypress event to send message:
  add_sticky_btn_reflection.addEventListener('click', function (event) {
    if (msg_reflection.value.length > 0) {
                                                                            // check click and non-empty message
      channel.push('shout', {                                               // send message to server on "shout" channel
        name: name_reflection.value || "anon",                              // get value of "name" from DOM
        message: msg_reflection.value,                                      // get value of message text from DOM
        week: getCorrectId($(week_reflection).attr('id')),                  // get value of week id
        day: getCorrectId($(day_reflection).attr('id')),                    // get value of day id
        temp_room_id: temp_room_id_reflection,                              // get value of associated temp_room_id  
      });
      msg_reflection.value = '';                                            // reset message input
    }
  });

  // Listen for click  keypress event to send message:
  add_sticky_btn_happiness.addEventListener('click', function (event) {
    if (msg_happiness.value.length > 0) {                                  // check click and non-empty message
      channel.push('shout', {                                              // send message to server on "shout" channel
        name: name_happiness.value || "anon",                              // get value of "name" from DOM
        message: msg_happiness.value,                                      // get value of message text from DOM
        week: getCorrectId($(week_happiness).attr('id')),                  // get value of week id
        day: getCorrectId($(day_happiness).attr('id')),                    // get value of day id
        temp_room_id: temp_room_id_happiness,                              // get value of associated temp_room_id  
      });
      msg_happiness.value = 'n/a';                                            // reset message input
    }
  });

}