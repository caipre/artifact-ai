defmodule ArtifactAi.Artifacts.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo
  alias Ecto.Multi

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Artifacts.Prompt

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
