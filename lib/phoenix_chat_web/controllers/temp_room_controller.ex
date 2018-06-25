defmodule PhoenixChatWeb.TempRoomController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.Temporary
  alias PhoenixChat.Temporary.TempRoom

  def index(conn, _params) do
    temp_rooms = Temporary.list_temp_rooms()
    render(conn, "index.html", temp_rooms: temp_rooms)
  end

  def new(conn, _params) do
    # Temporarily auto-create room with default name
    # changeset = Temporary.change_temp_room(%TempRoom{})
    # render(conn, "new.html", changeset: changeset)
    case Temporary.create_temp_room(%{"name" => "temp_room"}) do
      {:ok, temp_room} ->
        conn
        |> put_flash(:info, "Temp room created successfully.")
        |> redirect(to: temp_room_path(conn, :show, temp_room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"temp_room" => temp_room_params}) do
    case Temporary.create_temp_room(temp_room_params) do
      {:ok, temp_room} ->
        conn
        |> put_flash(:info, "Temp room created successfully.")
        |> redirect(to: temp_room_path(conn, :show, temp_room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug} = params) do
    temp_room = Temporary.get_temp_room!(slug)
    render(conn, "show.html", temp_room: temp_room)
  end

  def edit(conn, %{"slug" => slug}) do
    temp_room = Temporary.get_temp_room!(slug)
    changeset = Temporary.change_temp_room(temp_room)
    render(conn, "edit.html", temp_room: temp_room, changeset: changeset)
  end

  def update(conn, %{"slug" => slug, "temp_room" => temp_room_params}) do
    temp_room = Temporary.get_temp_room!(slug)

    case Temporary.update_temp_room(temp_room, temp_room_params) do
      {:ok, temp_room} ->
        conn
        |> put_flash(:info, "Temp room updated successfully.")
        |> redirect(to: temp_room_path(conn, :show, temp_room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", temp_room: temp_room, changeset: changeset)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    temp_room = Temporary.get_temp_room!(slug)
    {:ok, _temp_room} = Temporary.delete_temp_room(temp_room)

    conn
    |> put_flash(:info, "Temp room deleted successfully.")
    |> redirect(to: temp_room_path(conn, :index))
  end
end
