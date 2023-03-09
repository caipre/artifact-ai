defmodule ArtifactAi.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo
  alias Ecto.Multi

  alias ArtifactAi.Image
  alias ArtifactAi.Prompt
  alias ArtifactAi.User

  def create(attrs, %User{} = user) do
    Multi.new()
    |> Multi.insert(
      :prompt,
      user
      |> Ecto.build_assoc(:prompts)
      |> Prompt.changeset(attrs)
    )
    |> Multi.insert(:image, fn %{prompt: prompt} ->
      Ecto.build_assoc(prompt, :images, user_id: user.id)
      |> Image.changeset(attrs)
    end)
    |> Repo.transaction()
  end

  def create(attrs, %Prompt{} = prompt) do
    prompt
    |> Ecto.build_assoc(:images, user_id: prompt.user_id)
    |> Image.changeset(attrs)
    |> Repo.insert()
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
end
