defmodule PhoenixChatWeb.PageControllerTest do
  use PhoenixChatWeb.ConnCase

  test "GET w1", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "w1"
  end

  test "GET w2", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "w2"
  end
end
