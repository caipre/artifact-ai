defmodule ArtifactAi.Repo do
  use Ecto.Repo,
    otp_app: :artifact_ai,
    adapter: Ecto.Adapters.Postgres
end
