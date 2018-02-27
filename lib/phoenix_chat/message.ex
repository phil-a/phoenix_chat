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
    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:name, :message, :week, :day])
    |> validate_required([:message, :week, :day])
  end

  def get_messages(limit \\ 20) do
    Repo.all(Message, limit: limit)
  end
end
