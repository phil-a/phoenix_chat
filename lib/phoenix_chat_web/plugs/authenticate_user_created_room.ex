defmodule PhoenixChatWeb.Plugs.AuthenticateUserCreatedRoom do
  import Plug.Conn
  import Phoenix.Controller
  
  alias PhoenixChat.Repo
  alias PhoenixChat.Permanent.Room
  alias PhoenixChatWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if current_user_created_room?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You did not create this room.")
      |> redirect(to: Helpers.room_path(conn, :index))
      |> halt()
    end
  end

  defp current_user_created_room?(conn) do
    creator_id(conn) === user_id(conn)
  end

  defp creator_id(conn) do
    Repo.get(Room, room_id(conn))
    |> Map.get(:creator_id)
  end

  defp room_id(conn) do
    %{ "id" => room_id } = conn.path_params
    room_id
  end

  defp user_id(conn) do
    conn.assigns.current_user.id
  end

end

