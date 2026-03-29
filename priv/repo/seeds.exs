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

alias PhoenixChat.Accounts

# Create a default admin user if environment variables are set
name = System.get_env("ADMIN_NAME") || "Admin"
email = System.get_env("ADMIN_EMAIL") || "admin@example.com"
password = System.get_env("ADMIN_PASSWORD") || "secret123456"

case Accounts.get_user_by_email(email) do
  nil ->
    {:ok, _user} =
      Accounts.register_user(%{
        name: name,
        email: email,
        password: password
      })

    IO.puts("Created admin user: #{email}")

  _user ->
    IO.puts("Admin user already exists: #{email}")
end
