defmodule PhoenixChatWeb.RoomLive.Show do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Repo
  alias PhoenixChat.Permanent
  alias PhoenixChat.Permanent.{Room, Message, UserRoom}
  alias PhoenixChatWeb.Presence

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    current_user = socket.assigns.current_user
    room = Permanent.get_room!(id)

    # Check membership
    user_room = Repo.get_by(UserRoom, user_id: current_user.id, room_id: id)

    if is_nil(user_room) do
      {:ok,
       socket
       |> put_flash(:error, "You are not a member of this room.")
       |> push_navigate(to: ~p"/rooms")}
    else
      messages = Permanent.list_messages_for_room(room.id)

      if connected?(socket) do
        Phoenix.PubSub.subscribe(PhoenixChat.PubSub, "room:#{room.id}")
        Presence.track(self(), "room:#{room.id}", current_user.name, %{
          online_at: System.system_time(:second)
        })
      end

      {:ok,
       socket
       |> assign(:room, room)
       |> assign(:messages, messages)
       |> assign(:active_tab, :reflection)
       |> assign(:selected_week, "w1")
       |> assign(:selected_day, "m")
       |> assign(:presences, Presence.list("room:#{room.id}"))
       |> assign(:show_users_modal, false)
       |> assign(:show_sticky_modal, false)
       |> assign(:page_title, room.name)}
    end
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff"}, socket) do
    room = socket.assigns.room
    {:noreply, assign(socket, :presences, Presence.list("room:#{room.id}"))}
  end

  def handle_info({:new_message, message}, socket) do
    {:noreply, assign(socket, :messages, socket.assigns.messages ++ [message])}
  end

  def handle_info({:delete_message, msg_id}, socket) do
    messages = Enum.reject(socket.assigns.messages, &(&1.id == msg_id))
    {:noreply, assign(socket, :messages, messages)}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, String.to_existing_atom(tab))}
  end

  def handle_event("select_week", %{"week" => week}, socket) do
    {:noreply, assign(socket, :selected_week, week)}
  end

  def handle_event("select_day", %{"day" => day}, socket) do
    {:noreply, assign(socket, :selected_day, day)}
  end

  def handle_event("toggle_users_modal", _params, socket) do
    {:noreply, assign(socket, :show_users_modal, !socket.assigns.show_users_modal)}
  end

  def handle_event("toggle_sticky_modal", _params, socket) do
    {:noreply, assign(socket, :show_sticky_modal, !socket.assigns.show_sticky_modal)}
  end

  def handle_event("close_sticky_modal", _params, socket) do
    {:noreply, assign(socket, :show_sticky_modal, false)}
  end

  def handle_event("post_sticky", %{"message" => message_text}, socket) do
    current_user = socket.assigns.current_user
    room = socket.assigns.room
    week = socket.assigns.selected_week
    day = socket.assigns.selected_day

    attrs = %{
      "message" => message_text,
      "name" => current_user.name,
      "week" => week,
      "day" => day,
      "user_id" => current_user.id,
      "room_id" => room.id
    }

    case Permanent.create_message(attrs) do
      {:ok, msg} ->
        Phoenix.PubSub.broadcast(PhoenixChat.PubSub, "room:#{room.id}", {:new_message, msg})
        {:noreply, assign(socket, :show_sticky_modal, false)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not post message.")}
    end
  end

  def handle_event("post_happiness", %{"day" => day}, socket) do
    current_user = socket.assigns.current_user
    room = socket.assigns.room

    attrs = %{
      "message" => "vote",
      "name" => current_user.name,
      "week" => "h1",
      "day" => day,
      "user_id" => current_user.id,
      "room_id" => room.id
    }

    case Permanent.create_message(attrs) do
      {:ok, msg} ->
        Phoenix.PubSub.broadcast(PhoenixChat.PubSub, "room:#{room.id}", {:new_message, msg})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not post vote.")}
    end
  end

  def handle_event("delete_message", %{"id" => msg_id}, socket) do
    msg = Permanent.get_message!(msg_id)

    if msg.user_id == socket.assigns.current_user.id do
      Permanent.delete_message(msg)
      Phoenix.PubSub.broadcast(PhoenixChat.PubSub, "room:#{socket.assigns.room.id}", {:delete_message, msg.id})
    end

    {:noreply, socket}
  end

  # Helper to filter messages by week and day
  defp messages_for(messages, week, day) do
    Enum.filter(messages, fn msg -> msg.week == week && msg.day == day end)
  end

  defp online_users(presences) do
    Map.keys(presences)
  end

  defp day_label("m"), do: "Monday"
  defp day_label("t"), do: "Tuesday"
  defp day_label("w"), do: "Wednesday"
  defp day_label("th"), do: "Thursday"
  defp day_label("f"), do: "Friday"
  defp day_label(other), do: other
end
