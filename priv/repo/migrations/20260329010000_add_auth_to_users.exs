defmodule PhoenixChat.Repo.Migrations.AddAuthToUsers do
  use Ecto.Migration

  def change do
    # Add hashed_password to existing users table
    alter table(:users) do
      add :hashed_password, :string
      add :confirmed_at, :naive_datetime
    end

    # Create users_tokens table for session management
    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
