defmodule PhoenixChat.Temporary.TempRoom.NameSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug

  def build_slug(sources, _changeset) do
    scrubbed_name = sources
    |> String.downcase
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
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

  @doc false
  def changeset(%TempRoom{} = temp_room, attrs) do
    temp_room
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name])
    |> NameSlug.maybe_generate_slug
    |> NameSlug.unique_constraint
  end

  defimpl Phoenix.Param, for: Temporary.TempRoom do
    def to_param(%{slug: slug}) do
      "#{slug}"
    end
  end
end
