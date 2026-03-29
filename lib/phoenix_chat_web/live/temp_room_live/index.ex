defmodule PhoenixChatWeb.TempRoomLive.Index do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Temporary

  @impl true
  def mount(_params, _session, socket) do
    temp_rooms = Temporary.list_temp_rooms()
    {:ok, assign(socket, :temp_rooms, temp_rooms)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Temp Rooms")}
  end

  @impl true
  def handle_event("create_room", _params, socket) do
    case Temporary.create_temp_room(%{"name" => "temp_room"}) do
      {:ok, temp_room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room '#{temp_room.slug}' created. Self-destructs in: 1 day")
         |> push_navigate(to: ~p"/temp/#{temp_room.slug}")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not create room.")}
    end
  end

  def handle_event("join_room", %{"slug" => slug}, socket) do
    slug = String.trim(String.downcase(slug))

    if slug != "" do
      {:noreply, push_navigate(socket, to: ~p"/temp/#{slug}")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto">
      <.header>
        Temporary Rooms
        <:subtitle>Create or join an anonymous room that self-destructs in 24 hours</:subtitle>
      </.header>

      <div class="mt-8 flex gap-4">
        <.button phx-click="create_room">
          Create New Room
        </.button>
      </div>

      <div class="mt-8">
        <h3 class="text-sm font-semibold text-gray-400 mb-4">Join by Slug</h3>
        <form phx-submit="join_room" class="flex gap-2">
          <input
            type="text"
            name="slug"
            placeholder="room-slug"
            class="flex-1 rounded-lg bg-gray-700 border-gray-600 text-white placeholder-gray-400 focus:border-blue-500 focus:ring-0"
          />
          <.button type="submit">Join</.button>
        </form>
      </div>

      <div :if={@temp_rooms != []} class="mt-8">
        <h3 class="text-sm font-semibold text-gray-400 mb-4">Active Rooms</h3>
        <div class="space-y-2">
          <.link
            :for={room <- @temp_rooms}
            navigate={~p"/temp/#{room.slug}"}
            class="block bg-gray-800 rounded p-3 hover:bg-gray-700 transition"
          >
            <span class="text-blue-400">{room.slug}</span>
            <span class="text-gray-500 text-sm ml-2">({room.name})</span>
          </.link>
        </div>
      </div>
    </div>
    """
  end
end
