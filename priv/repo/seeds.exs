# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixChat.Repo.insert!(%PhoenixChat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

PhoenixChat.Coherence.User.changeset(%PhoenixChat.Coherence.User{}, %{name: System.get_env("COHERENCE_EMAIL_FROM_NAME"), email: System.get_env("COHERENCE_EMAIL_FROM_EMAIL"), password: "secret", password_confirmation: "secret"})
|> PhoenixChat.Repo.insert!