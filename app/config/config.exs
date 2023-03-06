# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :artifact_ai,
  ecto_repos: [ArtifactAi.Repo]

# Configure the repo
config :artifact_ai, ArtifactAi.Repo, migration_timestamps: [type: :utc_datetime]

# Configures the endpoint
config :artifact_ai, ArtifactAiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ArtifactAiWeb.ErrorHTML, json: ArtifactAiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ArtifactAi.PubSub,
  live_view: [signing_salt: "yueQFycb"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :artifact_ai, ArtifactAi.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Sentry
config :sentry,
  dsn:
    "https://1869c16d7cc5448fb13f99401ad5974e@o4504670167498752.ingest.sentry.io/4504670177198080",
  included_environments: ~w(production development),
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{env: Mix.env()}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
