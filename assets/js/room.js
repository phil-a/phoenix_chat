import socket from "./socket"
import {Presence} from "phoenix"

if (window.location.pathname.split("/")[1] === "rooms") {
console.log("ROOMS")

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

// Modal functions
$( "#online-users-button" ).click(function() {
  $('#onlineUsersModal').modal('toggle');
});

$( "#add-sticky-button" ).click(function() {
  $('#addStickyModal').modal('toggle');
});

function getCorrectUl(payload) {
  var {week, day} = payload;
  return $(document.getElementById(week + "-" + day)).find("ul")[0];
}

function messageBelongsToUser(payload) {
  return $("#current_user").data("user-id") === payload.msg_user_id;
}

function renderThumbtack() {
  return `<button class="btn btn-link btn-danger remove-sticky">
            <i class="fas fa-thumbtack"></i>
          </button>`
}

// Get id from option id
function getCorrectId(str) {
  return str.split("-")[1];
}

function handleChangeElement(el, id) {
  $(el.currentTarget).children("input").prop("checked", true);
  $(document.getElementById(id)).find("input").parent().removeClass("active");
  $(document.getElementById(id)).find("input:checked").parent().addClass("active");
  console.log($(document.getElementById(id)).find("input:checked")[0]);
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
  return btn.addEventListener("click", (el) => {
    day = handleChangeElement(el, "day-options-radio")
  });
});

//Connect to chat 'room' when logged in
  let room = $('.reflection-page').data("room") || "lobby";
  let channel = socket.channel('room:' + room, {});               // connect to chat "room"

  // Sync state
  channel.on('presence_state', state => {
    presences = Presence.syncState(presences, state)
    renderUsers(presences)
  });
  // Sync diff
  channel.on('presence_diff', diff => {
    presences = Presence.syncDiff(presences, diff)
    renderUsers(presences)
  });

  channel.on('shout', function (payload) {                            // listen to shout event
    let thumbtack = messageBelongsToUser(payload) ? renderThumbtack() : "";
    var li = $(document.createElement("li"))                        // create new list item
      .addClass("col-6 col-md-6 col-lg-12 col-xl-6")[0]                          
      
      $(li).attr("id", `msg-${payload.msg_id}`);
      $(li).data("id", payload.msg_id);
      $(li).data("user", payload.msg_user_id);
      $(li).data("room", payload.room_id);
      var name = payload.name || 'anon';                              // get name from payload or use default
      li.innerHTML = 
      `
        <b>${name}</b>:<br/>
        ${payload.message}
        ${thumbtack}
      `;                                                              // set li contents
      getCorrectUl(payload).appendChild(li);                          // append to list    

      // Attach event listener if user created
      if (messageBelongsToUser(payload)) {
        $(document.getElementById(`msg-${payload.msg_id}`))           // Add remove event listener for each card   
        .children(".remove-sticky")[0]
        .addEventListener('click', function (event) {                 // check click
        channel.push('remove', {                                      // delete message to server on "remove" channel
          msg_id: payload.msg_id,
          msg_user_id: payload.msg_user_id
        });
        });
      }
  });

  channel.on('remove', function (payload) {                      // listen to remove event
    $(`#msg-${payload.msg_id}`).remove()                         // remove element
  });

  channel.join();                                               // join channel
  var room_id = $('.reflection-page').data("room");
  var msg = document.getElementById('msg');                     // message input field
  var add_sticky_btn = document.getElementById('add-sticky');   // add sticky button
  var week = $(document.getElementById('week-options-radio'))   // radio buttons for week
              .find("input:checked")[0]
  var day = $(document.getElementById('day-options-radio'))     // radio buttons for day
              .find("input:checked")[0]            

  // Listen for click  keypress event to send message:
  add_sticky_btn.addEventListener('click', function (event) {
    if (msg.value.length > 0) {                                  // check click and non-empty message
      channel.push('shout', {                                    // send message to server on "shout" channel
        name: "",                                                // get value of "name" from DOM
        message: msg.value,                                      // get value of message text from DOM
        week: getCorrectId($(week).attr('id')),                  // get value of week id
        day: getCorrectId($(day).attr('id')),                    // get value of day id
        room_id: room_id,
      });
      msg.value = '';                                            // reset message input
    }
  });



} 