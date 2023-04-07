defmodule ArtifactAi.Artifacts.Image do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Prompts.Prompt
  alias ArtifactAi.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "images" do
    belongs_to :user, User, type: Ecto.UUID
    belongs_to :prompt, Prompt, type: Ecto.UUID

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [])
    |> validate_required([])
  end
end
