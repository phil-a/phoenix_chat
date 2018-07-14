defmodule PhoenixChatWeb.TempRoomChannel do
  use PhoenixChatWeb, :channel
  alias PhoenixChat.{ Repo, Temporary }
  alias PhoenixChat.Temporary.{TempRoom, TempMessage}
  alias PhoenixChatWeb.Presence
  
  def join("temp_room:" <> temp_room_id, payload, socket) do
    IO.puts("JOIN")
    temp_room = Repo.get!(TempRoom, temp_room_id)
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, assign(socket, :temp_room, temp_room_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    IO.puts("PING")
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    IO.puts("SHOUT")
    TempMessage.changeset(%TempMessage{}, payload)
    |> Repo.insert
  

    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    temp_room = Repo.get(TempRoom, socket.assigns[:temp_room])
    user_name = socket.assigns[:user_id]
    push(socket, "presence_state", Presence.list(socket))
    {:ok, _} = Presence.track(socket, user_name, %{ online_at: inspect(System.system_time(:seconds)) })
    Temporary.list_messages_for_room(temp_room.id)
    |> Enum.each(fn msg -> push(socket, "shout", %{
      name: msg.name,
      message: msg.message,
      week: msg.week,
      day: msg.day,
    }) end)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end