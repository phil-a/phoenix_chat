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

function handleChangeElement(id) {
  $(document.getElementById(id)).find("input").parent().removeClass("active");
  $(document.getElementById(id)).find("input:checked").parent().addClass("active");
  return $(document.getElementById(id)).find("input:checked")[0];
}

// Add event listeners to week buttons
$("#week-options-radio").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", () => {
    week = handleChangeElement("week-options-radio") 
  });
});

// Add event listeners to day buttons
$("#day-options-radio").find("label > input").map(function(i, e) {
  let btn = $(document.getElementById(e.id)).parent()[0];
  return btn.addEventListener("click", () => {
    day = handleChangeElement("day-options-radio")
  });
});

//Connect to chat 'room'
var channel = socket.channel('room:lobby', {});               // connect to chat "room"

channel.on('shout', function (payload) {                      // listen to shout event
  var li = $(document.createElement("li"))
            .addClass("col-md-6 fade")[0]                          // create new list item
  var name = payload.name || 'anon';                          // get name from payload or use default
  li.innerHTML = `<b>${name}</b>:<br/>${payload.message}`;        // set li contents
  getCorrectUl(payload).appendChild(li);
  li.addClass('fade');                      // append to list
});

channel.join();                                               // join channel

var name = document.getElementById('name');                   // name of message sender
var msg = document.getElementById('msg');                     // message input field
var week = $(document.getElementById('week-options-radio'))
            .find("input:checked")[0]
var day = $(document.getElementById('day-options-radio'))
            .find("input:checked")[0]

// Listen for [ Enter ]  keypress event to send message:
msg.addEventListener('keypress', function (event) {
  if (event.keyCode == 13 && msg.value.length > 0) {           // check keypress and non-empty message
    channel.push('shout', {                                    // send message to server on "shout" channel
      name: name.value,                                        // get value of "name" from DOM
      message: msg.value,                                      // get value of message text from DOM
      week: getCorrectId($(week).attr('id')),                  // get value of week id
      day: getCorrectId($(day).attr('id')),                    // get value of day id
    });
    msg.value = '';                                            // reset message input
  }
});