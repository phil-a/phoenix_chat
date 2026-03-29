defmodule PhoenixChat.Temporary.TempMessage do
  use Ecto.Schema

  import Ecto.Changeset

  alias PhoenixChat.Temporary.TempRoom

  schema "temp_messages" do
    field :day, :string
    field :message, :string
    field :name, :string
    field :week, :string
    belongs_to :temp_room, TempRoom

    timestamps()
  end

  def changeset(%__MODULE__{} = temp_message, attrs) do
    temp_message
    |> cast(attrs, [:message, :name, :week, :day, :temp_room_id])
    |> validate_required([:message, :name, :week, :day])
  end
end
