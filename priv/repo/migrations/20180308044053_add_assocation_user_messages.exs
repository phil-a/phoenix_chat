defmodule PhoenixChat.Repo.Migrations.AddAssocationUserMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :user_id, references(:users)
    end
  end
end
