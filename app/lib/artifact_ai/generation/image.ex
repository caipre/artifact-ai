defmodule ArtifactAi.Image do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Prompt
  alias ArtifactAi.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "images" do
    belongs_to :user, User, type: Ecto.UUID
    belongs_to :prompt, Prompt

    field :url

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
