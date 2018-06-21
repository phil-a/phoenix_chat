defmodule PhoenixChatWeb.TempRoomControllerTest do
  use PhoenixChatWeb.ConnCase

  alias PhoenixChat.Temporary

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:temp_room) do
    {:ok, temp_room} = Temporary.create_temp_room(@create_attrs)
    temp_room
  end

  describe "index" do
    test "lists all temp_rooms", %{conn: conn} do
      conn = get conn, temp_room_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Temp rooms"
    end
  end

  describe "new temp_room" do
    test "renders form", %{conn: conn} do
      conn = get conn, temp_room_path(conn, :new)
      assert html_response(conn, 200) =~ "New Temp room"
    end
  end

  describe "create temp_room" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, temp_room_path(conn, :create), temp_room: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == temp_room_path(conn, :show, id)

      conn = get conn, temp_room_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Temp room"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, temp_room_path(conn, :create), temp_room: @invalid_attrs
      assert html_response(conn, 200) =~ "New Temp room"
    end
  end

  describe "edit temp_room" do
    setup [:create_temp_room]

    test "renders form for editing chosen temp_room", %{conn: conn, temp_room: temp_room} do
      conn = get conn, temp_room_path(conn, :edit, temp_room)
      assert html_response(conn, 200) =~ "Edit Temp room"
    end
  end

  describe "update temp_room" do
    setup [:create_temp_room]

    test "redirects when data is valid", %{conn: conn, temp_room: temp_room} do
      conn = put conn, temp_room_path(conn, :update, temp_room), temp_room: @update_attrs
      assert redirected_to(conn) == temp_room_path(conn, :show, temp_room)

      conn = get conn, temp_room_path(conn, :show, temp_room)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, temp_room: temp_room} do
      conn = put conn, temp_room_path(conn, :update, temp_room), temp_room: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Temp room"
    end
  end

  describe "delete temp_room" do
    setup [:create_temp_room]

    test "deletes chosen temp_room", %{conn: conn, temp_room: temp_room} do
      conn = delete conn, temp_room_path(conn, :delete, temp_room)
      assert redirected_to(conn) == temp_room_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, temp_room_path(conn, :show, temp_room)
      end
    end
  end

  defp create_temp_room(_) do
    temp_room = fixture(:temp_room)
    {:ok, temp_room: temp_room}
  end
end
