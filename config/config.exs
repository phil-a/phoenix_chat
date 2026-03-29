import Config

config :phoenix_chat,
  ecto_repos: [PhoenixChat.Repo],
  generators: [timestamp_type: :utc_datetime]

config :phoenix_chat, PhoenixChatWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PhoenixChatWeb.ErrorHTML, json: PhoenixChatWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhoenixChat.PubSub,
  live_view: [signing_salt: "TqQ6u9Q/"]

config :phoenix_chat, PhoenixChat.Scheduler,
  jobs: [
    {"*/15 * * * *", {PhoenixChat.Temporary, :heartbeat, []}}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.17.11",
  phoenix_chat: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  phoenix_chat: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"
