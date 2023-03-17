defmodule ArtifactAi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.Address
  alias ArtifactAi.Accounts.Auth
  alias ArtifactAi.Accounts.Session
  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Commerce.Order

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "users" do
    field :email, :string
    field :name, :string
    field :image, :string

    has_one :auth, Auth
    has_one :session, Session
    has_many :addresses, Address
    has_many :prompts, Prompt
    has_many :images, Image
    has_many :carts, Cart
    has_many :orders, Order

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :image])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
