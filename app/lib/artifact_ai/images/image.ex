defmodule ArtifactAi.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :url, :string
    field :user_id, :id
    field :prompt_id, :id

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :user_id, :prompt_id])
    |> validate_required([:url, :user_id, :prompt_id])
  end
end
