defmodule PhoenixChatWeb.TempMessageController do
  use PhoenixChatWeb, :controller

  alias PhoenixChat.Temporary
  alias PhoenixChat.Temporary.TempMessage

  def index(conn, _params) do
    temp_messages = Temporary.list_temp_messages()
    render(conn, "index.html", temp_messages: temp_messages)
  end

  def new(conn, _params) do
    changeset = Temporary.change_temp_message(%TempMessage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"temp_message" => temp_message_params}) do
    case Temporary.create_temp_message(temp_message_params) do
      {:ok, temp_message} ->
        conn
        |> put_flash(:info, "Temp message created successfully.")
        |> redirect(to: temp_message_path(conn, :show, temp_message))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    temp_message = Temporary.get_temp_message!(id)
    render(conn, "show.html", temp_message: temp_message)
  end

  def edit(conn, %{"id" => id}) do
    temp_message = Temporary.get_temp_message!(id)
    changeset = Temporary.change_temp_message(temp_message)
    render(conn, "edit.html", temp_message: temp_message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "temp_message" => temp_message_params}) do
    temp_message = Temporary.get_temp_message!(id)

    case Temporary.update_temp_message(temp_message, temp_message_params) do
      {:ok, temp_message} ->
        conn
        |> put_flash(:info, "Temp message updated successfully.")
        |> redirect(to: temp_message_path(conn, :show, temp_message))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", temp_message: temp_message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    temp_message = Temporary.get_temp_message!(id)
    {:ok, _temp_message} = Temporary.delete_temp_message(temp_message)

    conn
    |> put_flash(:info, "Temp message deleted successfully.")
    |> redirect(to: temp_message_path(conn, :index))
  end
end
