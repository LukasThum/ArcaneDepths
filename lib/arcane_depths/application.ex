defmodule ArcaneDepths.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ArcaneDepthsWeb.Telemetry,
      # Start the Ecto repository
      ArcaneDepths.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ArcaneDepths.PubSub},
      # Start Finch
      {Finch, name: ArcaneDepths.Finch},
      # Start the Endpoint (http/https)
      ArcaneDepthsWeb.Endpoint
      # Start a worker by calling: ArcaneDepths.Worker.start_link(arg)
      # {ArcaneDepths.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArcaneDepths.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArcaneDepthsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
