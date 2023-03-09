defmodule ArtifactAi.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Image
  alias ArtifactAi.User

  schema "prompts" do
    belongs_to :user, User, type: Ecto.UUID

    field :prompt

    has_many :images, Image

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:prompt, :user_id])
    |> validate_required([:prompt, :user_id])
  end
end
