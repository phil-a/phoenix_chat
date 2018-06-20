defmodule PhoenixChat.Repo.Migrations.CreateTempMessages do
  use Ecto.Migration

  def change do
    create table(:temp_messages) do
      add :message, :string
      add :name, :string
      add :week, :string
      add :day, :string
      add :temp_room_id, references(:temp_rooms, on_delete: :delete_all), null: false

      timestamps()
    end

  end
end
