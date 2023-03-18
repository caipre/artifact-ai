defmodule ArtifactAi.Prompts do
  @moduledoc false
  alias ArtifactAi.Repo
  import Ecto.Query

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Artifacts.Prompt

  def create(%User{} = user, attrs) do
    user
    |> Ecto.build_assoc(:prompts)
    |> Prompt.changeset(attrs)
    |> Repo.insert()
  end

  def list() do
    Repo.all(Prompt)
  end

  def from!(id) do
    query =
      from i in Prompt,
        where: like(type(i.id, :string), ^"#{id}%")

    Repo.one!(query)
  end

  def get!(id) do
    Repo.get!(Prompt, id)
  end
end
