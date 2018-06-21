defmodule PhoenixChatWeb.TempMessageControllerTest do
  use PhoenixChatWeb.ConnCase

  alias PhoenixChat.Temporary

  @create_attrs %{day: "some day", message: "some message", name: "some name", week: "some week"}
  @update_attrs %{day: "some updated day", message: "some updated message", name: "some updated name", week: "some updated week"}
  @invalid_attrs %{day: nil, message: nil, name: nil, week: nil}

  def fixture(:temp_message) do
    {:ok, temp_message} = Temporary.create_temp_message(@create_attrs)
    temp_message
  end

  describe "index" do
    test "lists all temp_messages", %{conn: conn} do
      conn = get conn, temp_message_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Temp messages"
    end
  end

  describe "new temp_message" do
    test "renders form", %{conn: conn} do
      conn = get conn, temp_message_path(conn, :new)
      assert html_response(conn, 200) =~ "New Temp message"
    end
  end

  describe "create temp_message" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, temp_message_path(conn, :create), temp_message: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == temp_message_path(conn, :show, id)

      conn = get conn, temp_message_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Temp message"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, temp_message_path(conn, :create), temp_message: @invalid_attrs
      assert html_response(conn, 200) =~ "New Temp message"
    end
  end

  describe "edit temp_message" do
    setup [:create_temp_message]

    test "renders form for editing chosen temp_message", %{conn: conn, temp_message: temp_message} do
      conn = get conn, temp_message_path(conn, :edit, temp_message)
      assert html_response(conn, 200) =~ "Edit Temp message"
    end
  end

  describe "update temp_message" do
    setup [:create_temp_message]

    test "redirects when data is valid", %{conn: conn, temp_message: temp_message} do
      conn = put conn, temp_message_path(conn, :update, temp_message), temp_message: @update_attrs
      assert redirected_to(conn) == temp_message_path(conn, :show, temp_message)

      conn = get conn, temp_message_path(conn, :show, temp_message)
      assert html_response(conn, 200) =~ "some updated day"
    end

    test "renders errors when data is invalid", %{conn: conn, temp_message: temp_message} do
      conn = put conn, temp_message_path(conn, :update, temp_message), temp_message: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Temp message"
    end
  end

  describe "delete temp_message" do
    setup [:create_temp_message]

    test "deletes chosen temp_message", %{conn: conn, temp_message: temp_message} do
      conn = delete conn, temp_message_path(conn, :delete, temp_message)
      assert redirected_to(conn) == temp_message_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, temp_message_path(conn, :show, temp_message)
      end
    end
  end

  defp create_temp_message(_) do
    temp_message = fixture(:temp_message)
    {:ok, temp_message: temp_message}
  end
end
