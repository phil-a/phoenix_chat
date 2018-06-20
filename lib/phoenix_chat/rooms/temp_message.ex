defmodule PhoenixChat.Rooms.TempMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixChat.Repo
  alias PhoenixChat.Rooms.{TempMessage, TempRoom}
  import Ecto.Query, only: [from: 2]

  schema "temp_messages" do
    field :day, :string
    field :message, :string
    field :name, :string
    field :week, :string
    belongs_to :temp_room, TempRoom

    timestamps()
  end

  @doc false
  def changeset(%TempMessage{} = temp_message, attrs) do
    temp_message
    |> cast(attrs, [:message, :name, :week, :day, :temp_room_id])
    |> validate_required([:message, :name, :week, :day])
  end

  def get_messages(limit \\ 20) do
    Repo.all(TempMessage, limit: limit)
  end

  def get_messages_for_room(temp_room_id) do
    query = from m in TempMessage,
            where: m.temp_room_id == ^temp_room_id,
            select: m
    Repo.all(query)
  end
end
