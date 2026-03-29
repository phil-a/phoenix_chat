defmodule PhoenixChatWeb.TempRoomLive.Show do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Temporary
  alias PhoenixChatWeb.Presence

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    temp_room = Temporary.get_temp_room!(slug)
    messages = Temporary.list_messages_for_room(temp_room.id)

    # For temp rooms, use a mnemonic slug as anonymous user name
    user_name =
      case session do
        %{"temp_user_name" => name} -> name
        _ -> PhoenixChat.SlugGenerator.generate_slug(1)
      end

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixChat.PubSub, "temp_room:#{temp_room.id}")
      Presence.track(self(), "temp_room:#{temp_room.id}", user_name, %{
        online_at: System.system_time(:second)
      })
    end

    {:ok,
     socket
     |> assign(:temp_room, temp_room)
     |> assign(:messages, messages)
     |> assign(:user_name, user_name)
     |> assign(:active_tab, :reflection)
     |> assign(:selected_week, "w1")
     |> assign(:selected_day, "m")
     |> assign(:presences, Presence.list("temp_room:#{temp_room.id}"))
     |> assign(:show_users_modal, false)
     |> assign(:show_sticky_modal, false)
     |> assign(:show_name_prompt, user_name == nil)
     |> assign(:page_title, "Temp Room: #{temp_room.slug}")}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff"}, socket) do
    temp_room = socket.assigns.temp_room
    {:noreply, assign(socket, :presences, Presence.list("temp_room:#{temp_room.id}"))}
  end

  def handle_info({:new_message, message}, socket) do
    {:noreply, assign(socket, :messages, socket.assigns.messages ++ [message])}
  end

  @impl true
  def handle_event("set_name", %{"name" => name}, socket) do
    name = String.trim(name)

    if name != "" do
      # Re-track presence with new name
      temp_room = socket.assigns.temp_room
      Presence.untrack(self(), "temp_room:#{temp_room.id}", socket.assigns.user_name)
      Presence.track(self(), "temp_room:#{temp_room.id}", name, %{
        online_at: System.system_time(:second)
      })

      {:noreply,
       socket
       |> assign(:user_name, name)
       |> assign(:show_name_prompt, false)
       |> assign(:presences, Presence.list("temp_room:#{temp_room.id}"))}
    else
      {:noreply, socket}
    end
  end

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
    temp_room = socket.assigns.temp_room
    week = socket.assigns.selected_week
    day = socket.assigns.selected_day

    attrs = %{
      "message" => message_text,
      "name" => socket.assigns.user_name,
      "week" => week,
      "day" => day,
      "temp_room_id" => temp_room.id
    }

    case Temporary.create_temp_message(attrs) do
      {:ok, msg} ->
        Phoenix.PubSub.broadcast(PhoenixChat.PubSub, "temp_room:#{temp_room.id}", {:new_message, msg})
        {:noreply, assign(socket, :show_sticky_modal, false)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not post message.")}
    end
  end

  def handle_event("post_happiness", %{"day" => day}, socket) do
    temp_room = socket.assigns.temp_room

    attrs = %{
      "message" => "vote",
      "name" => socket.assigns.user_name,
      "week" => "h1",
      "day" => day,
      "temp_room_id" => temp_room.id
    }

    case Temporary.create_temp_message(attrs) do
      {:ok, msg} ->
        Phoenix.PubSub.broadcast(PhoenixChat.PubSub, "temp_room:#{temp_room.id}", {:new_message, msg})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not post vote.")}
    end
  end

  def handle_event("copy_url", _params, socket) do
    {:noreply, put_flash(socket, :info, "URL copied! Share it with your team.")}
  end

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
