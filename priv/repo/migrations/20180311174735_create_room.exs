defmodule PhoenixChat.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false
      add :creator_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:rooms, [:creator_id])
    create unique_index(:rooms, [:name])
  end
end
