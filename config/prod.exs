import Config

config :phoenix_chat, PhoenixChatWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
