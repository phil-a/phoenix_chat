defmodule PhoenixChat.Temporary.TempRoom.NameSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug

  def build_slug(_sources, _changeset) do
    "#{MnemonicSlugs.generate_slug(2)}"
  end
end

defmodule PhoenixChat.Temporary.TempRoom do
  use Ecto.Schema

  import Ecto.Changeset

  alias PhoenixChat.Temporary.{TempRoom, TempMessage}
  alias PhoenixChat.Temporary.TempRoom.NameSlug
  @derive {Phoenix.Param, key: :slug}

  schema "temp_rooms" do
    field :name, :string
    field :slug, NameSlug.Type

    has_many :temp_messages, TempMessage

    timestamps()
  end

  def changeset(%TempRoom{} = temp_room, attrs) do
    temp_room
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name])
    |> NameSlug.maybe_generate_slug()
    |> NameSlug.unique_constraint()
  end
end
