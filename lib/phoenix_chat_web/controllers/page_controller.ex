defmodule PhoenixChatWeb.PageController do
  use PhoenixChatWeb, :controller

  def index(conn, _params) do
    redirect conn, to: "/rooms"
  end
end
