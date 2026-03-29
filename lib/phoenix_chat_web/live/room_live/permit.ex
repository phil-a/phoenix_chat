defmodule PhoenixChatWeb.RoomLive.Permit do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Repo
  alias PhoenixChat.Permanent
  alias PhoenixChat.Permanent.UserRoom
  alias PhoenixChat.Accounts

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    room = Permanent.get_room!(id) |> Repo.preload([:creator, :users])
    current_user = socket.assigns.current_user

    if room.creator_id != current_user.id do
      {:ok,
       socket
       |> put_flash(:error, "You are not authorized to manage permissions.")
       |> push_navigate(to: ~p"/rooms")}
    else
      {:ok,
       socket
       |> assign(:room, room)
       |> assign(:page_title, "Room Permissions - #{room.name}")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto">
      <.back navigate={~p"/rooms"}>Back to rooms</.back>

      <.header class="mt-4">
        Permissions for {@room.name}
        <:subtitle>Manage who has access to this room</:subtitle>
      </.header>

      <div class="mt-8">
        <h3 class="text-sm font-semibold text-gray-400 mb-4">Current Members</h3>
        <div class="space-y-2">
          <div :for={user <- @room.users} class="flex items-center justify-between bg-gray-800 rounded p-3">
            <div>
              <span class="text-white">{user.name}</span>
              <span class="text-gray-400 text-sm ml-2">{user.email}</span>
              <span :if={user.id == @room.creator_id} class="text-xs text-blue-400 ml-2">(creator)</span>
            </div>
            <button
              :if={user.id != @room.creator_id}
              phx-click="kick"
              phx-value-user-id={user.id}
              data-confirm={"Are you sure you want to remove #{user.name}?"}
              class="text-red-400 hover:text-red-300 text-sm"
            >
              Remove
            </button>
          </div>
        </div>
      </div>

      <div class="mt-8">
        <h3 class="text-sm font-semibold text-gray-400 mb-4">Add Member by Email</h3>
        <form phx-submit="add_member" class="flex gap-2">
          <input
            type="email"
            name="email"
            placeholder="user@example.com"
            class="flex-1 rounded-lg bg-gray-700 border-gray-600 text-white placeholder-gray-400 focus:border-blue-500 focus:ring-0"
            required
          />
          <.button type="submit">Add</.button>
        </form>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("kick", %{"user-id" => user_id}, socket) do
    room = socket.assigns.room

    case Repo.get_by(UserRoom, user_id: user_id, room_id: room.id) do
      nil ->
        {:noreply, put_flash(socket, :error, "User is not a member of this room.")}

      user_room ->
        Repo.delete(user_room)
        room = Permanent.get_room!(room.id) |> Repo.preload([:creator, :users])

        {:noreply,
         socket
         |> put_flash(:info, "User removed successfully.")
         |> assign(:room, room)}
    end
  end

  def handle_event("add_member", %{"email" => email}, socket) do
    room = socket.assigns.room
    email = String.trim(email)

    case Accounts.get_user_by_email(email) do
      nil ->
        {:noreply, put_flash(socket, :error, "#{email} cannot be found.")}

      user ->
        changeset = UserRoom.changeset(%UserRoom{}, %{room_id: room.id, user_id: user.id})

        case Repo.insert(changeset) do
          {:ok, _} ->
            room = Permanent.get_room!(room.id) |> Repo.preload([:creator, :users])

            {:noreply,
             socket
             |> put_flash(:info, "#{email} added successfully.")
             |> assign(:room, room)}

          {:error, _} ->
            {:noreply, put_flash(socket, :error, "#{email} is already in room.")}
        end
    end
  end
end
