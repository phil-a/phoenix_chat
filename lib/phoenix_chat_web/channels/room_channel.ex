defmodule PhoenixChatWeb.RoomChannel do
  use PhoenixChatWeb, :channel
  alias PhoenixChat.{ Repo, Message, Coherence.User }

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
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

    payload = %{  "day" => payload["day"],
                  "message" => payload["message"],
                  "name" => user.name,
                  "week" => payload["week"]}
    Message.changeset(%Message{}, payload)
    |> Repo.insert

    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Message.get_messages()
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
