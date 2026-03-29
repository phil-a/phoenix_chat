import Config

config :bcrypt_elixir, :log_rounds, 1

config :phoenix_chat, PhoenixChatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kev8uVxEoheL+DXbc+bGOF/WwVxvbO/SkRmGMVBW0UCCR9TlemvHynqiopqEOe4v",
  server: false

config :logger, level: :warning

config :phoenix_chat, PhoenixChat.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "phoenix_chat_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 16
