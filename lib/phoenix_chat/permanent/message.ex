defmodule PhoenixChat.Permanent.Message do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  
  alias PhoenixChat.{Repo, Coherence.User}
  alias PhoenixChat.Permanent.{ Message, Room }

  schema "messages" do
    field :message, :string
    field :name, :string
    field :week, :string
    field :day, :string
    belongs_to :user, User
    belongs_to :room, Room
    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:name, :message, :week, :day, :user_id, :room_id])
    |> validate_required([:message, :week, :day, :user_id, :room_id])
  end

end
