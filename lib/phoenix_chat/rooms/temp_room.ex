defmodule PhoenixChat.Rooms.TempRoom do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixChat.Rooms.{TempRoom, TempMessage}


  schema "temp_rooms" do
    field :name, :string
    has_many :temp_messages, TempMessage

    timestamps()
  end

  @doc false
  def changeset(%TempRoom{} = temp_room, attrs) do
    temp_room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
