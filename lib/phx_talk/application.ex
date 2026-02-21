defmodule PhxTalk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxTalkWeb.Telemetry,
      PhxTalk.Repo,
      {DNSCluster, query: Application.get_env(:phx_talk, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxTalk.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhxTalk.Finch},
      # Start a worker by calling: PhxTalk.Worker.start_link(arg)
      # {PhxTalk.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxTalkWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxTalk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxTalkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
