defmodule ArtifactAi.Prompts do
  @moduledoc false
  alias ArtifactAi.Repo
  import Ecto.Query

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Prompts.Prompt

  def get!(id) do
    Repo.get!(Prompt, id)
  end

  def from!(shortid) do
    Repo.from!(Prompt, shortid)
  end

  def create(%User{} = user, attrs) do
    user
    |> Ecto.build_assoc(:prompts)
    |> Prompt.changeset(attrs)
    |> Repo.insert()
  end

  def list() do
    query =
      from p in Prompt,
        join: u in assoc(p, :user),
        join: i in assoc(p, :images),
        preload: [:user, :images]

    Repo.all(query)
  end
end
