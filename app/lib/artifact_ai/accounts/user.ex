defmodule ArtifactAi.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Image
  alias ArtifactAi.Prompt
  alias ArtifactAi.Token

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field :email
    field :name
    field :image
    field :iss

    has_one :token, Token
    has_many :prompts, Prompt
    has_many :images, Image

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :image, :iss])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
