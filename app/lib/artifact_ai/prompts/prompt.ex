defmodule ArtifactAi.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.User

  schema "prompts" do
    field :prompt, :string
    belongs_to :user, User, type: Ecto.UUID

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:prompt, :user_id])
    |> validate_required([:prompt, :user_id])
  end
end
