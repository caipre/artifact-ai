defmodule ArtifactAi.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo

  alias ArtifactAi.Image
  alias ArtifactAi.Prompt

  def create(attrs \\ %{}, %Prompt{} = prompt) do
    prompt
    |> Ecto.build_assoc(:images, user_id: prompt.user_id)
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def get!(id) do
    Repo.get!(Image, id)
  end

  def list() do
    Repo.all(Image)
  end
end
