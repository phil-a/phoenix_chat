defmodule PhoenixChat.Repo.Migrations.AddRoomAssociationToMessages do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE messages DROP CONSTRAINT messages_user_id_fkey"
    alter table(:messages) do
      add :room_id, references(:rooms, on_delete: :delete_all), null: false
      modify :user_id, references(:users, on_delete: :delete_all), null: false
    end
    create index(:messages, [:room_id])
    create index(:messages, [:user_id])
  end

  def down do
    execute "ALTER TABLE messages DROP CONSTRAINT messages_user_id_fkey"
    alter table(:messages) do
      modify :user_id, references(:users, on_delete: :nothing)
    end
  end
end
