defmodule PhoenixChat.Repo.Migrations.CreateTempRooms do
  use Ecto.Migration

  def change do
    create table(:temp_rooms) do
      add :name, :string

      timestamps()
    end

  end
end
