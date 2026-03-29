defmodule PhoenixChat.Temporary.TempRoom do
  use Ecto.Schema

  import Ecto.Changeset

  alias PhoenixChat.Temporary.{TempRoom, TempMessage}
  @derive {Phoenix.Param, key: :slug}

  schema "temp_rooms" do
    field :name, :string
    field :slug, :string

    has_many :temp_messages, TempMessage

    timestamps()
  end

  def changeset(%TempRoom{} = temp_room, attrs) do
    temp_room
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name])
    |> maybe_generate_slug()
    |> unique_constraint(:slug)
  end

  defp maybe_generate_slug(changeset) do
    case get_field(changeset, :slug) do
      nil -> put_change(changeset, :slug, PhoenixChat.SlugGenerator.generate_slug(2))
      _ -> changeset
    end
  end
end
