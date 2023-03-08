defmodule ArtifactAi.Prompts do
  import Ecto.Query, warn: false
  alias ArtifactAi.Repo

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Prompts.Prompt

  @doc """
  Returns the list of prompts.
  """
  def list_prompts do
    Repo.all(Prompt)
  end

  @doc """
  Gets a single prompt.

  Raises `Ecto.NoResultsError` if the Prompt does not exist.
  """
  def get_prompt!(id), do: Repo.get!(Prompt, id)

  @doc """
  Creates a prompt.
  """
  def create_prompt(attrs \\ %{}) do
    %Prompt{}
    |> Prompt.changeset(attrs)
    |> Repo.insert()
  end
end
