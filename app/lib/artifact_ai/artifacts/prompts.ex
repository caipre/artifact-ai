defmodule ArtifactAi.Artifacts.Prompts do
  @moduledoc """
  The Prompts context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo

  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Accounts.User

  def create(attrs \\ %{}, %User{} = user) do
    user
    |> Ecto.build_assoc(:prompts)
    |> Prompt.changeset(attrs)
    |> Repo.insert()
  end

  def from!(id) do
    query =
      from p in Prompt,
        where: like(type(p.id, :string), ^"#{id}%")

    Repo.one!(query)
  end

  def get!(id) do
    Repo.get!(Prompt, id)
  end

  def list() do
    Repo.all(Prompt)
  end
end
