defmodule PhoenixChat.TempMessageTest do
  use PhoenixChat.ModelCase

  alias PhoenixChat.TempMessage

  @valid_attrs %{day: "some day", message: "some message", name: "some name", week: "some week"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TempMessage.changeset(%TempMessage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TempMessage.changeset(%TempMessage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
