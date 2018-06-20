defmodule PhoenixChat.TempRoomTest do
  use PhoenixChat.ModelCase

  alias PhoenixChat.TempRoom

  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TempRoom.changeset(%TempRoom{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TempRoom.changeset(%TempRoom{}, @invalid_attrs)
    refute changeset.valid?
  end
end
