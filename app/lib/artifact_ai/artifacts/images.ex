defmodule ArtifactAi.Images do
  @moduledoc false
  alias ArtifactAi.Repo
  import Ecto.Query

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Prompts.Prompt

  def create(%User{} = user, %Prompt{} = prompt) do
    Ecto.build_assoc(user, :images, prompt_id: prompt.id)
    |> Repo.insert()
  end

  def url(%Image{} = image) do
    "https://d3h1bvh1ced4x7.cloudfront.net/image-#{image.id}.png"
  end

  def list() do
    query =
      from i in Image,
        join: u in assoc(i, :user),
        join: p in assoc(i, :prompt),
        order_by: [desc: i.inserted_at],
        preload: [:user, :prompt]

    Repo.all(query)
  end

  def get!(id) do
    Repo.get!(Image, id)
  end

  def from!(shortid) do
    Repo.from!(Image, shortid)
  end
end
