defmodule ArtifactAi.Prompts do
  @moduledoc """
  The Prompts context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo

  alias ArtifactAi.Prompt
  alias ArtifactAi.User

  def create(attrs \\ %{}, %User{} = user) do
    user
    |> Ecto.build_assoc(:prompts)
    |> Prompt.changeset(attrs)
    |> Repo.insert()
  end

  def get!(id) do
    Repo.get!(Prompt, id)
  end

  def list() do
    Repo.all(Prompt)
  end
end
