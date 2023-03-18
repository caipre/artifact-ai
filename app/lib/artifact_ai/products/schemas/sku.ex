defmodule ArtifactAi.Products.Sku do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Products.Offer
  alias ArtifactAi.Products.Product
  alias ArtifactAi.Products.SkuProductAttribute

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "skus" do
    belongs_to :product, Product, type: Ecto.UUID

    has_many :attributes, SkuProductAttribute
    has_many :offers, Offer

    timestamps()
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [])
    |> validate_required([])
  end
end
