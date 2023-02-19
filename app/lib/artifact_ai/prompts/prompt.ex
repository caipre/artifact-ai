defmodule ArtifactAi.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prompts" do
    field :prompt, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:prompt, :user_id])
    |> validate_required([:prompt, :user_id])
  end
end
