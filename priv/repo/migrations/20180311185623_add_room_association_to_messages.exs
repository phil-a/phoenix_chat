defmodule PhoenixChat.Repo.Migrations.AddRoomAssociationToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room_id, references(:rooms, on_delete: :nothing), null: false
    end
  end
end
