defmodule PhoenixChat.Temporary.TempMessage do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  
  alias PhoenixChat.Repo
  alias PhoenixChat.Temporary.{ TempMessage, TempRoom }

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

end
