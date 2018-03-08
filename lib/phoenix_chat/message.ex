defmodule PhoenixChat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixChat.Message
  alias PhoenixChat.Repo


  schema "messages" do
    field :message, :string
    field :name, :string
    field :week, :string
    field :day, :string
    belongs_to :user, PhoenixChat.Coherence.User
    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:name, :message, :week, :day, :user_id])
    |> validate_required([:message, :week, :day, :user_id])
  end

  def get_messages(limit \\ 20) do
    Repo.all(Message, limit: limit)
  end
end
