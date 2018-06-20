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
import socket from "./socket"

if (window.location.pathname.split("/")[1] === "temp_rooms") {

  console.log("TEMP_ROOMS")

const DAY_OPTIONS = ["option-m", "option-t", "option-w", "option-th", "option-f"];
const WEEK_OPTIONS = ["option-w1", "option-w2"];

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
  return $(document.getElementById(id)).find("input:checked")[0];
}

// Add event listeners to week buttons
$("#week-options-radio").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", (el) => {
    week = handleChangeElement(el, "week-options-radio") 
  });
});

// Add event listeners to day buttons
$("#day-options-radio").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", (el, ) => {
    day = handleChangeElement(el, "day-options-radio")
  });
});

//Connect to chat 'room'
let room = $('.reflection-page').data("room") || "lobby";
var channel = socket.channel('temp_room:' + room, {});         // connect to chat "temp_room"
channel.on('shout', function (payload) {                      // listen to shout event
  var li = $(document.createElement("li"))
            .addClass("col-md-6")[0]                     // create new list item
  var name = payload.name || 'anon';                          // get name from payload or use default
  li.innerHTML = `<b>${name}</b>:<br/>${payload.message}`;    // set li contents
  getCorrectUl(payload).appendChild(li);                      // append to list
                        
});

channel.join()                                               // join channel
.receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

var temp_room_id = $('.reflection-page').data("room");
var name = document.getElementById('name');                   // name of message sender
var msg = document.getElementById('msg');                     // message input field
var add_sticky_btn = document.getElementById('add-sticky');   // add sticky button
var week = $(document.getElementById('week-options-radio'))
            .find("input:checked")[0]
var day = $(document.getElementById('day-options-radio'))
            .find("input:checked")[0]
console.log(day)

  // Listen for click  keypress event to send message:
  add_sticky_btn.addEventListener('click', function (event) {
    if (msg.value.length > 0) {                                  // check click and non-empty message
      channel.push('shout', {                                    // send message to server on "shout" channel
        name: "",                                                // get value of "name" from DOM
        message: msg.value,                                      // get value of message text from DOM
        week: getCorrectId($(week).attr('id')),                  // get value of week id
        day: getCorrectId($(day).attr('id')),                    // get value of day id
        temp_room_id: temp_room_id,                              // get value of associated temp_room_id  
      });
      msg.value = '';                                            // reset message input
    }
  });

}