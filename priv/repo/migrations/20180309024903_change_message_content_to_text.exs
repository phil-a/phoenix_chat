defmodule PhoenixChat.Repo.Migrations.ChangeMessageNameToText do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      modify :message, :text
    end
  end
end
