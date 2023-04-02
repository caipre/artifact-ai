defmodule ArtifactAi.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "prompts" do
    belongs_to :user, User, type: Ecto.UUID
    field :prompt
    has_many :images, Image

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:prompt])
    |> validate_required([:prompt])
    |> validate_length(:prompt, max: 255)
  end
end
