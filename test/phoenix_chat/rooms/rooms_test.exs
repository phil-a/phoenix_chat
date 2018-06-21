defmodule PhoenixChat.TemporaryTest do
  use PhoenixChat.DataCase

  alias PhoenixChat.Temporary.Rooms

  describe "temp_rooms" do
    alias PhoenixChat.Temporary.TempRoom

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def temp_room_fixture(attrs \\ %{}) do
      {:ok, temp_room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_temp_room()

      temp_room
    end

    test "list_temp_rooms/0 returns all temp_rooms" do
      temp_room = temp_room_fixture()
      assert Rooms.list_temp_rooms() == [temp_room]
    end

    test "get_temp_room!/1 returns the temp_room with given id" do
      temp_room = temp_room_fixture()
      assert Rooms.get_temp_room!(temp_room.id) == temp_room
    end

    test "create_temp_room/1 with valid data creates a temp_room" do
      assert {:ok, %TempRoom{} = temp_room} = Rooms.create_temp_room(@valid_attrs)
      assert temp_room.name == "some name"
    end

    test "create_temp_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_temp_room(@invalid_attrs)
    end

    test "update_temp_room/2 with valid data updates the temp_room" do
      temp_room = temp_room_fixture()
      assert {:ok, temp_room} = Rooms.update_temp_room(temp_room, @update_attrs)
      assert %TempRoom{} = temp_room
      assert temp_room.name == "some updated name"
    end

    test "update_temp_room/2 with invalid data returns error changeset" do
      temp_room = temp_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_temp_room(temp_room, @invalid_attrs)
      assert temp_room == Rooms.get_temp_room!(temp_room.id)
    end

    test "delete_temp_room/1 deletes the temp_room" do
      temp_room = temp_room_fixture()
      assert {:ok, %TempRoom{}} = Rooms.delete_temp_room(temp_room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_temp_room!(temp_room.id) end
    end

    test "change_temp_room/1 returns a temp_room changeset" do
      temp_room = temp_room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_temp_room(temp_room)
    end
  end

  describe "temp_messages" do
    alias PhoenixChat.Temporary.TempMessage

    @valid_attrs %{day: "some day", message: "some message", name: "some name", week: "some week"}
    @update_attrs %{day: "some updated day", message: "some updated message", name: "some updated name", week: "some updated week"}
    @invalid_attrs %{day: nil, message: nil, name: nil, week: nil}

    def temp_message_fixture(attrs \\ %{}) do
      {:ok, temp_message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_temp_message()

      temp_message
    end

    test "list_temp_messages/0 returns all temp_messages" do
      temp_message = temp_message_fixture()
      assert Rooms.list_temp_messages() == [temp_message]
    end

    test "get_temp_message!/1 returns the temp_message with given id" do
      temp_message = temp_message_fixture()
      assert Rooms.get_temp_message!(temp_message.id) == temp_message
    end

    test "create_temp_message/1 with valid data creates a temp_message" do
      assert {:ok, %TempMessage{} = temp_message} = Rooms.create_temp_message(@valid_attrs)
      assert temp_message.day == "some day"
      assert temp_message.message == "some message"
      assert temp_message.name == "some name"
      assert temp_message.week == "some week"
    end

    test "create_temp_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_temp_message(@invalid_attrs)
    end

    test "update_temp_message/2 with valid data updates the temp_message" do
      temp_message = temp_message_fixture()
      assert {:ok, temp_message} = Rooms.update_temp_message(temp_message, @update_attrs)
      assert %TempMessage{} = temp_message
      assert temp_message.day == "some updated day"
      assert temp_message.message == "some updated message"
      assert temp_message.name == "some updated name"
      assert temp_message.week == "some updated week"
    end

    test "update_temp_message/2 with invalid data returns error changeset" do
      temp_message = temp_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_temp_message(temp_message, @invalid_attrs)
      assert temp_message == Rooms.get_temp_message!(temp_message.id)
    end

    test "delete_temp_message/1 deletes the temp_message" do
      temp_message = temp_message_fixture()
      assert {:ok, %TempMessage{}} = Rooms.delete_temp_message(temp_message)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_temp_message!(temp_message.id) end
    end

    test "change_temp_message/1 returns a temp_message changeset" do
      temp_message = temp_message_fixture()
      assert %Ecto.Changeset{} = Rooms.change_temp_message(temp_message)
    end
  end
end
