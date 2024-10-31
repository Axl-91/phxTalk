defmodule PhxChatRoom.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxChatRoomWeb.Telemetry,
      PhxChatRoom.Repo,
      {DNSCluster, query: Application.get_env(:phx_chat_room, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxChatRoom.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhxChatRoom.Finch},
      # Start a worker by calling: PhxChatRoom.Worker.start_link(arg)
      # {PhxChatRoom.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxChatRoomWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxChatRoom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxChatRoomWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
