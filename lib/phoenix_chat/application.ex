defmodule PhoenixChat.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixChat.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixChat.PubSub},
      PhoenixChatWeb.Presence,
      PhoenixChatWeb.Endpoint,
      PhoenixChat.Scheduler
    ]

    opts = [strategy: :one_for_one, name: PhoenixChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PhoenixChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
