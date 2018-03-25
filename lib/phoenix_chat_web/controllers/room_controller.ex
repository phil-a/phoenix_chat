defmodule PhoenixChatWeb.RoomController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.{ Room, Repo, UserRoom, Coherence.User }

  def index(conn, _params) do
    rooms = Repo.all(Room)
    current_user = Coherence.current_user(conn) |> Repo.preload(:rooms)
    render(conn, "index.html", rooms: rooms, user_rooms: current_user.rooms)
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    current_user = Coherence.current_user(conn)
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
        |> put_flash(:error, "You must first join the room.")
        |> redirect(to: room_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)
    changeset = Room.changeset(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Repo.get!(Room, id)
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

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: room_path(conn, :index))
  end
end
