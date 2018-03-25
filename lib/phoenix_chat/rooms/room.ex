defmodule PhoenixChat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias PhoenixChat.{Message, Coherence.User, UserRoom}

  schema "rooms" do
    field :name, :string
    many_to_many :users, User, join_through: "user_rooms"
    has_many :messages, Message

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
