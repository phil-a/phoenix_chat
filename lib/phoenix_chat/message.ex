defmodule PhoenixChat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixChat.{ Message, Room, Repo }
  import Ecto.Query, only: [from: 2]

  schema "messages" do
    field :message, :string
    field :name, :string
    field :week, :string
    field :day, :string
    belongs_to :user, PhoenixChat.Coherence.User
    belongs_to :room, PhoenixChat.Room
    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:name, :message, :week, :day, :user_id, :room_id])
    |> validate_required([:message, :week, :day, :user_id, :room_id])
  end

  def get_messages(limit \\ 20) do
    Repo.all(Message, limit: limit)
  end

  def get_messages_for_room(room_id) do
    query = from m in Message,
            where: m.room_id == ^room_id,
            select: m
    Repo.all(query)
  end
end
