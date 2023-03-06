defmodule ArtifactAi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Logger.add_backend(Sentry.LoggerBackend)

    children = [
      # Start the Telemetry supervisor
      ArtifactAiWeb.Telemetry,
      # Start the Ecto repository
      ArtifactAi.Repo,
      # Start the Google ID Jwks strategy
      ArtifactAiWeb.Jwks.GoogleId,
      # Start the PubSub system
      {Phoenix.PubSub, name: ArtifactAi.PubSub},
      # Start Finch
      {Finch, name: ArtifactAi.Finch},
      # Start the Endpoint (http/https)
      ArtifactAiWeb.Endpoint
      # Start a worker by calling: ArtifactAi.Worker.start_link(arg)
      # {ArtifactAi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArtifactAi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArtifactAiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
