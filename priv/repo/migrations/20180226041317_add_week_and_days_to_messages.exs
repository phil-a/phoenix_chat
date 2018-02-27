defmodule PhoenixChat.Repo.Migrations.AddWeekAndDaysToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :week, :string
      add :day, :string
    end

  end
end
