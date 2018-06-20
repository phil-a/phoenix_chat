defmodule PhoenixChatWeb.TempMessageController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.Rooms
  alias PhoenixChat.Rooms.TempMessage

  def index(conn, _params) do
    temp_messages = Rooms.list_temp_messages()
    render(conn, "index.html", temp_messages: temp_messages)
  end

  def new(conn, _params) do
    changeset = Rooms.change_temp_message(%TempMessage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"temp_message" => temp_message_params}) do
    case Rooms.create_temp_message(temp_message_params) do
      {:ok, temp_message} ->
        conn
        |> put_flash(:info, "Temp message created successfully.")
        |> redirect(to: temp_message_path(conn, :show, temp_message))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    temp_message = Rooms.get_temp_message!(id)
    render(conn, "show.html", temp_message: temp_message)
  end

  def edit(conn, %{"id" => id}) do
    temp_message = Rooms.get_temp_message!(id)
    changeset = Rooms.change_temp_message(temp_message)
    render(conn, "edit.html", temp_message: temp_message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "temp_message" => temp_message_params}) do
    temp_message = Rooms.get_temp_message!(id)

    case Rooms.update_temp_message(temp_message, temp_message_params) do
      {:ok, temp_message} ->
        conn
        |> put_flash(:info, "Temp message updated successfully.")
        |> redirect(to: temp_message_path(conn, :show, temp_message))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", temp_message: temp_message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    temp_message = Rooms.get_temp_message!(id)
    {:ok, _temp_message} = Rooms.delete_temp_message(temp_message)

    conn
    |> put_flash(:info, "Temp message deleted successfully.")
    |> redirect(to: temp_message_path(conn, :index))
  end
end
