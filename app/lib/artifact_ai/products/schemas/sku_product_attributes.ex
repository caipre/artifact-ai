defmodule ArtifactAi.Products.SkuProductAttribute do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Products.Sku
  alias ArtifactAi.Products.ProductAttribute

  @primary_key false
  schema "sku_product_attributes" do
    belongs_to :sku, Sku, type: Ecto.UUID
    belongs_to :product_attribute, ProductAttribute, type: Ecto.UUID

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [])
    |> validate_required([])
  end
end
