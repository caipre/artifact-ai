defmodule ArtifactAi.Products.Offer do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Products.Sku

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "offers" do
    belongs_to :sku, Sku, type: Ecto.UUID
    field :price, :decimal
    field :currency, :string
    field :expires_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(offers, attrs) do
    offers
    |> cast(attrs, [:price, :currency, :expires_at])
    |> validate_required([:price, :currency, :expires_at])
  end
end
