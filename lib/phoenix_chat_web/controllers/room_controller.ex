defmodule PhoenixChatWeb.RoomController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.{ Room, Repo, UserRoom }

  def index(conn, _params) do
    rooms = Repo.all(Room)
    render(conn, "index.html", rooms: rooms)
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
        |> redirect(to: room_path(conn, :show, room))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Room could not be joined.")
        |> render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)
    render(conn, "show.html", room: room)
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
