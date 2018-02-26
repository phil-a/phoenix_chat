defmodule PhoenixChatWeb.PageControllerTest do
  use PhoenixChatWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "msg-list"
  end
end
