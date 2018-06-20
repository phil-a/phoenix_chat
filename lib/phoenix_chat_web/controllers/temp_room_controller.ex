defmodule PhoenixChatWeb.TempRoomController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.Rooms
  alias PhoenixChat.Rooms.TempRoom

  def index(conn, _params) do
    temp_rooms = Rooms.list_temp_rooms()
    render(conn, "index.html", temp_rooms: temp_rooms)
  end

  def new(conn, _params) do
    changeset = Rooms.change_temp_room(%TempRoom{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"temp_room" => temp_room_params}) do
    case Rooms.create_temp_room(temp_room_params) do
      {:ok, temp_room} ->
        conn
        |> put_flash(:info, "Temp room created successfully.")
        |> redirect(to: temp_room_path(conn, :show, temp_room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    temp_room = Rooms.get_temp_room!(id)
    render(conn, "show.html", temp_room: temp_room)
  end

  def edit(conn, %{"id" => id}) do
    temp_room = Rooms.get_temp_room!(id)
    changeset = Rooms.change_temp_room(temp_room)
    render(conn, "edit.html", temp_room: temp_room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "temp_room" => temp_room_params}) do
    temp_room = Rooms.get_temp_room!(id)

    case Rooms.update_temp_room(temp_room, temp_room_params) do
      {:ok, temp_room} ->
        conn
        |> put_flash(:info, "Temp room updated successfully.")
        |> redirect(to: temp_room_path(conn, :show, temp_room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", temp_room: temp_room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    temp_room = Rooms.get_temp_room!(id)
    {:ok, _temp_room} = Rooms.delete_temp_room(temp_room)

    conn
    |> put_flash(:info, "Temp room deleted successfully.")
    |> redirect(to: temp_room_path(conn, :index))
  end
end