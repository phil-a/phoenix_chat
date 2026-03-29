defmodule PhoenixChatWeb.RoomLive.Index do
  use PhoenixChatWeb, :live_view

  alias PhoenixChat.Repo
  alias PhoenixChat.Permanent
  alias PhoenixChat.Permanent.Room
  alias PhoenixChat.Permanent.UserRoom

  @impl true
  def mount(_params, _session, socket) do
    rooms = Permanent.list_rooms()
    current_user = socket.assigns.current_user |> Repo.preload(:rooms)

    {:ok,
     socket
     |> assign(:rooms, rooms)
     |> assign(:user_rooms, current_user.rooms)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Room")
    |> assign(:room, %Room{})
    |> assign(:changeset, Room.changeset(%Room{}, %{}))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    room = Permanent.get_room!(id) |> Repo.preload(:creator)

    if room.creator_id == socket.assigns.current_user.id do
      socket
      |> assign(:page_title, "Edit Room")
      |> assign(:room, room)
      |> assign(:changeset, Room.changeset(room, %{}))
    else
      socket
      |> put_flash(:error, "You are not authorized to edit this room.")
      |> push_navigate(to: ~p"/rooms")
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Rooms")
    |> assign(:room, nil)
  end

  @impl true
  def handle_event("join", %{"id" => room_id}, socket) do
    current_user = socket.assigns.current_user

    changeset =
      UserRoom.changeset(%UserRoom{}, %{room_id: room_id, user_id: current_user.id})

    case Repo.insert(changeset) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room joined successfully.")
         |> reload_rooms()}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "You are already a member of this room.")}
    end
  end

  def handle_event("leave", %{"id" => room_id}, socket) do
    current_user = socket.assigns.current_user

    case Repo.get_by(UserRoom, user_id: current_user.id, room_id: room_id) do
      nil ->
        {:noreply, put_flash(socket, :error, "You are not a member of this room.")}

      user_room ->
        Repo.delete(user_room)

        {:noreply,
         socket
         |> put_flash(:info, "Room left successfully.")
         |> reload_rooms()}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    room = Permanent.get_room!(id) |> Repo.preload(:creator)

    if room.creator_id == socket.assigns.current_user.id do
      import Ecto.Query
      from(ur in UserRoom, where: ur.room_id == ^id) |> Repo.delete_all()
      Repo.delete!(room)

      {:noreply,
       socket
       |> put_flash(:info, "Room deleted successfully.")
       |> reload_rooms()}
    else
      {:noreply, put_flash(socket, :error, "You are not authorized to delete this room.")}
    end
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    case socket.assigns.live_action do
      :new -> create_room(socket, room_params)
      :edit -> update_room(socket, room_params)
    end
  end

  defp create_room(socket, room_params) do
    current_user = socket.assigns.current_user
    room_params = Map.put(room_params, "creator", current_user)

    case Repo.insert(Room.changeset(%Room{}, room_params)) do
      {:ok, room} ->
        Repo.insert!(UserRoom.changeset(%UserRoom{}, %{user_id: current_user.id, room_id: room.id}))

        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully.")
         |> push_navigate(to: ~p"/rooms/#{room}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp update_room(socket, room_params) do
    room = socket.assigns.room
    room_params = Map.put(room_params, "creator", room.creator)

    case Repo.update(Room.changeset(room, room_params)) do
      {:ok, _room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room updated successfully.")
         |> push_navigate(to: ~p"/rooms")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp reload_rooms(socket) do
    rooms = Permanent.list_rooms()
    current_user = socket.assigns.current_user |> Repo.preload(:rooms, force: true)
    assign(socket, rooms: rooms, user_rooms: current_user.rooms)
  end

  defp user_joined_room?(room, user_rooms) do
    Enum.any?(user_rooms, fn ur -> ur.id == room.id end)
  end

  defp user_created_room?(user, room) do
    room = Repo.preload(room, :creator)
    room.creator_id == user.id
  end
end
