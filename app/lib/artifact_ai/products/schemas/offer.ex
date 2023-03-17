defmodule ArtifactAi.Products.Offers do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "offers" do
    field :currency, :string
    field :expires_at, :utc_datetime
    field :price, :decimal
    field :sku_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(offers, attrs) do
    offers
    |> cast(attrs, [:price, :currency, :expires_at])
    |> validate_required([:price, :currency, :expires_at])
  end
end
