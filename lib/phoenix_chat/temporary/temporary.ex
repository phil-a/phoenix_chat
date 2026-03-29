defmodule PhoenixChat.Temporary do
  @moduledoc """
  The Temporary context.
  """

  import Ecto.Query, warn: false
  alias PhoenixChat.Repo

  alias PhoenixChat.Temporary.TempRoom

  def list_temp_rooms do
    Repo.all(TempRoom)
  end

  def get_temp_room!(slug) do
    Repo.get_by!(TempRoom, slug: slug)
  end

  def create_temp_room(attrs \\ %{}) do
    %TempRoom{}
    |> TempRoom.changeset(attrs)
    |> Repo.insert()
  end

  def update_temp_room(%TempRoom{} = temp_room, attrs) do
    temp_room
    |> TempRoom.changeset(attrs)
    |> Repo.update()
  end

  def delete_temp_room(%TempRoom{} = temp_room) do
    Repo.delete(temp_room)
  end

  def heartbeat() do
    IO.puts("-------- HEARTBEAT ----------")

    TempRoom
    |> Repo.all()
    |> Repo.preload(:temp_messages)
    |> Enum.each(&delete_room_if_expired(&1))
  end

  def delete_room_if_expired(%TempRoom{} = temp_room) do
    last_message =
      temp_room
      |> Map.get(:temp_messages)
      |> List.last()

    diff =
      case last_message do
        nil ->
          NaiveDateTime.diff(NaiveDateTime.utc_now(), temp_room.inserted_at)

        msg ->
          NaiveDateTime.diff(NaiveDateTime.utc_now(), msg.inserted_at)
      end

    if diff > 86400 do
      IO.puts("#{diff} - DELETING")
      delete_temp_room(temp_room)
    else
      IO.puts("#{diff} - STILL ACTIVE")
    end
  end

  def change_temp_room(%TempRoom{} = temp_room, attrs \\ %{}) do
    TempRoom.changeset(temp_room, attrs)
  end

  alias PhoenixChat.Temporary.TempMessage

  def list_temp_messages do
    Repo.all(TempMessage)
  end

  def list_messages_for_room(temp_room_id) do
    query =
      from m in TempMessage,
        where: m.temp_room_id == ^temp_room_id,
        select: m

    Repo.all(query)
  end

  def get_temp_message!(id), do: Repo.get!(TempMessage, id)

  def create_temp_message(attrs \\ %{}) do
    %TempMessage{}
    |> TempMessage.changeset(attrs)
    |> Repo.insert()
  end

  def update_temp_message(%TempMessage{} = temp_message, attrs) do
    temp_message
    |> TempMessage.changeset(attrs)
    |> Repo.update()
  end

  def delete_temp_message(%TempMessage{} = temp_message) do
    Repo.delete(temp_message)
  end

  def change_temp_message(%TempMessage{} = temp_message, attrs \\ %{}) do
    TempMessage.changeset(temp_message, attrs)
  end
end
