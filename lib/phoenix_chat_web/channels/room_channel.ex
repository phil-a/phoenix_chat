defmodule PhoenixChatWeb.RoomChannel do
  use PhoenixChatWeb, :channel
  alias PhoenixChat.{ Repo, Message, Room, Coherence.User }
  alias PhoenixChatWeb.Presence

  def join("room:" <> room_id, payload, socket) do
    room = Repo.get!(Room, room_id)
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, assign(socket, :room, room)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)

    payload = %{  "user_id" => user.id,
                  "day" => payload["day"],
                  "message" => payload["message"],
                  "name" => user.name,
                  "week" => payload["week"],
                  "room_id" => payload["room_id"]}

    {_, %{id: msg_id, user_id: msg_user_id }} = 
    Message.changeset(%Message{}, payload)
    |> Repo.insert

    payload = payload
    |> Map.put("msg_user_id", msg_user_id)
    |> Map.put("msg_id", msg_id) 

    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("remove", payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    msg_id = Map.get(payload, "msg_id")
    msg_user_id = Map.get(payload, "msg_user_id")

    case msg_user_id == user.id do
      true ->
        Message 
        |> Repo.get(msg_id) 
        |> Repo.delete

        broadcast socket, "remove", payload
        {:noreply, socket}
      false ->
        broadcast socket, "remove", %{}
        {:noreply, socket}
    end
  end

  def handle_info(:after_join, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    room = Repo.get(Room, socket.assigns.room.id)
    push(socket, "presence_state", PhoenixChatWeb.Presence.list(socket))
    {:ok, _} = Presence.track(socket, user.name, %{ online_at: inspect(System.system_time(:seconds)) })
    IO.inspect(socket)
    Message.get_messages_for_room(room.id)
    |> Enum.each(fn msg -> push(socket, "shout", %{
      name: msg.name,
      message: msg.message,
      week: msg.week,
      day: msg.day,
      msg_id: msg.id,
      msg_user_id: msg.user_id,
    }) end)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
