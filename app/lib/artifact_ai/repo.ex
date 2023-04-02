defmodule ArtifactAi.Repo do
  use Ecto.Repo,
    otp_app: :artifact_ai,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  def from!(schema, id) do
    query =
      from i in schema,
        where: like(type(i.id, :string), ^"#{id}%")

    one(query)
  end
end
