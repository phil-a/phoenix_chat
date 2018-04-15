defmodule PhoenixChatWeb.RoomController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.{ Room, Repo, UserRoom, Coherence.User }
  alias PhoenixChatWeb.Plugs.AuthenticateUserCreatedRoom

  plug AuthenticateUserCreatedRoom when action in [:edit, :delete, :edit_permit, :update_permit]

  def index(conn, _params) do
    rooms = Repo.all(Room)
    current_user = Coherence.current_user(conn) |> Repo.preload(:rooms)
    render(conn, "index.html", rooms: rooms, user_rooms: current_user.rooms, current_user: current_user)
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    current_user = Coherence.current_user(conn)
    room_params = room_params |> Map.put("creator", current_user)
    changeset = Room.changeset(%Room{}, room_params)
    case Repo.insert(changeset) do
      {:ok, room} ->
        assoc_changeset = UserRoom.changeset(
          %UserRoom{},
          %{user_id: current_user.id, room_id: room.id}
        )
        Repo.insert(assoc_changeset)

        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: room_path(conn, :show, room))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Coherence.current_user(conn)
    room = Repo.get(Room, room_id)

    changeset = UserRoom.changeset(
      %UserRoom{},
      %{room_id: room.id, user_id: current_user.id}
    )
    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        conn
        |> put_flash(:info, "Room joined successfully.")
        |> redirect(to: room_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "You are already a member of this room.")
        |> redirect(to: room_path(conn, :index))
    end
  end

  def leave(conn, %{"id" => room_id}) do
    current_user = Coherence.current_user(conn)
    room = Repo.get(Room, room_id)
    user_room = UserRoom
    |> Repo.get_by(user_id: current_user.id, room_id: room_id)

    case user_room !== nil do
      true ->
        Repo.delete(user_room)
        conn
        |> put_flash(:info, "Room left successfully.")
        |> redirect(to: room_path(conn, :index))
      false ->
        conn
        |> put_flash(:error, "You are not a member of this room.")
        |> redirect(to: room_path(conn, :index))
    end
  end

  def kick(conn, %{"id" => room_id, "user_id" => user_id}) do
    user = Repo.get(User, user_id)
    room = Repo.get(Room, room_id)
    user_room = UserRoom
    |> Repo.get_by(user_id: user.id, room_id: room_id)

    case user_room !== nil do
      true ->
        Repo.delete(user_room)
        conn
        |> put_flash(:info, "User kicked successfully.")
        |> redirect(to: room_path(conn, :edit_permit, room_id))
      false ->
        conn
        |> put_flash(:error, "User is not a member of this room.")
        |> redirect(to: room_path(conn, :edit_permit, room_id))
    end
  end

  def edit_permit(conn, %{"id" => id}) do
    room = Repo.get!(Room, id) |> Repo.preload([:creator, :users])
    changeset = Room.changeset(room)
    render(conn, "permit.html", room: room, changeset: changeset)
  end

  def update_permit(conn, %{"id" => room_id, "room" => %{"email" => email}}) do
    user = Repo.get_by(User, email: String.trim(email))
    room = Repo.get(Room, room_id)

    changeset = UserRoom.changeset(
      %UserRoom{},
      %{room_id: room_id, user_id: get_user_id(user)}
    )
    case Repo.insert(changeset) do
      {:ok, _user_room} ->
         conn
         |> put_flash(:info, email <> " added successfully.")
         |> redirect(to: room_path(conn, :edit_permit, room))
      {:error, changeset} ->
        conn
        |> put_flash(:error, get_error(email, changeset.errors))
        |> redirect(to: room_path(conn, :edit_permit, room))
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Coherence.current_user(conn)
    room = Repo.get!(Room, id)
    user_room = UserRoom
    |> Repo.get_by(user_id: current_user.id, room_id: id)
    case user_room !== nil do
      true ->
        render(conn, "show.html", room: room)
      false ->
        conn
        |> put_flash(:error, "You are not a member of this room.")
        |> redirect(to: room_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    room = Repo.get!(Room, id) |> Repo.preload(:creator)
    changeset = Room.changeset(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Repo.get!(Room, id) |> Repo.preload(:creator)
    room_params = room_params |> Map.put("creator", room.creator)
    changeset = Room.changeset(room, room_params)

    case Repo.update(changeset) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: room_path(conn, :show, room))
      {:error, changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)
    
    # Here we delete the UserRoom association
    # before deleting the room
    UserRoom.get_user_rooms_for_room(id)
    |> Repo.delete_all()
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: room_path(conn, :index))
  end

  defp get_user_id(nil), do: nil
  defp get_user_id(user), do: user.id
  defp get_error(email, [user_id: {"can't be blank", [validation: :required]}]) do
    email <> " cannot be found."
  end
  defp get_error(email, _) do
    email <> " is already in room."
  end
end
