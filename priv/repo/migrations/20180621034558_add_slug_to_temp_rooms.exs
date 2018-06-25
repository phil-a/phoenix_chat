defmodule PhoenixChat.Repo.Migrations.AddSlugToTempRooms do
  use Ecto.Migration

  def change do
    alter table(:temp_rooms) do
      add :slug, :string
    end

    create index(:temp_rooms, [:slug], unique: true)
  end
end
