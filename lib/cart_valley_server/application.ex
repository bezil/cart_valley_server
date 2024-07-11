defmodule CartValleyServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CartValleyServerWeb.Telemetry,
      CartValleyServer.Repo,
      {DNSCluster, query: Application.get_env(:cart_valley_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CartValleyServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CartValleyServer.Finch},
      # Start a worker by calling: CartValleyServer.Worker.start_link(arg)
      # {CartValleyServer.Worker, arg},
      # Start to serve requests, typically the last entry
      CartValleyServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CartValleyServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CartValleyServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
