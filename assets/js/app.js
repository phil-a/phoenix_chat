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

//Connect to chat 'room'
var channel = socket.channel('room:lobby', {}); // connect to chat "room"

channel.on('shout', function (payload) {                      // listen to shout event
  var li = document.createElement("li");                      // create new list item
  var name = payload.name || 'anonymous';                     // get name from payload or use default
  li.innerHTML = '<b>' + name + '</b>: ' + payload.message;   // set li contents
  ul.appendChild(li);                                         // append to list
});

channel.join();                                               // join channel

var ul = document.getElementById('msg-list');                 // list of messages
var name = document.getElementById('name');                   // name of message sender
var msg = document.getElementById('msg');                     // message input field

// Listen for [ Enter ]  keypress event to send message:
msg.addEventListener('keypress', function (event) {
  if (event.keyCode == 13 && msg.value.length > 0) {           // check keypress and non-empty message
    channel.push('shout', {                                    // send message to server on "shout" channel
      name: name.value,                                        // get value of "name" from DOM
      message: msg.value,                                      // get value of message text from DOM
    });
    msg.value = '';                                            // reset message input
  }
});