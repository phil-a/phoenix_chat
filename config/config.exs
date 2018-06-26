# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_chat,
  ecto_repos: [PhoenixChat.Repo]

# Configures the endpoint
config :phoenix_chat, PhoenixChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kev8uVxEoheL+DXbc+bGOF/WwVxvbO/SkRmGMVBW0UCCR9TlemvHynqiopqEOe4v",
  render_errors: [view: PhoenixChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: PhoenixChat.Coherence.User,
  repo: PhoenixChat.Repo,
  module: PhoenixChat,
  web_module: PhoenixChatWeb,
  router: PhoenixChatWeb.Router,
  messages_backend: PhoenixChatWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: System.get_env("COHERENCE_EMAIL_FROM_NAME"),
  email_from_email: System.get_env("COHERENCE_EMAIL_FROM_EMAIL"),
  opts: [:rememberable, :invitable, :confirmable, :authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token]

config :coherence, PhoenixChatWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SENDGRID_API_KEY")
# %% End Coherence Configuration %%

config :phoenix_chat, PhoenixChat.Scheduler,
  jobs: [
    # Every second
    # {{:extended, "*/1 * * * *"}, {PhoenixChat.Temporary, :heartbeat, []}},

    # Every 15 minutes
    {"*/15 * * * *", {PhoenixChat.Temporary, :heartbeat, []}},
  ]
