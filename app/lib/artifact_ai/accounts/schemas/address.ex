defmodule ArtifactAi.Accounts.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "addresses" do
    belongs_to :user, User, type: Ecto.UUID
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :region, :string
    field :postcode, :string
    field :country, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:address1, :address2, :city, :region, :postcode, :country])
    |> validate_required([:address1, :city, :region, :postcode, :country])
    |> validate_length(:country, is: 2)
  end
end
