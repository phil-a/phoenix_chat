import Config

config :phoenix_chat, PhoenixChatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "kev8uVxEoheL+DXbc+bGOF/WwVxvbO/SkRmGMVBW0UCCR9TlemvHynqiopqEOe4v",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:phoenix_chat, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:phoenix_chat, ~w(--watch)]}
  ]

config :phoenix_chat, PhoenixChatWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/phoenix_chat_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_chat, PhoenixChat.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "phoenix_chat_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :phoenix_chat, dev_routes: true
