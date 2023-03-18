defmodule ArtifactAi.Images do
  @moduledoc false
  alias ArtifactAi.Repo
  import Ecto.Query

  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Accounts.User

  def create(%User{} = user, %Prompt{} = prompt, attrs) do
    Ecto.build_assoc(user, :images, prompt_id: prompt.id)
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def from!(id) do
    query =
      from i in Image,
        where: like(type(i.id, :string), ^"#{id}%")

    Repo.one!(query)
  end

  def get!(id) do
    Repo.get!(Image, id)
  end

  def list() do
    query =
      from i in Image,
        join: p in assoc(i, :prompt),
        order_by: [desc: i.inserted_at],
        preload: :prompt

    Repo.all(query)
  end

  def with_prompt_id(prompt_id) do
    query =
      from i in Image,
        where: i.prompt_id == ^prompt_id,
        order_by: [desc: i.inserted_at]

    Repo.all(query)
  end
end
