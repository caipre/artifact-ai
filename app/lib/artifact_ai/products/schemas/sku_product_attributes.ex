defmodule ArtifactAi.Products.SkuProductAttributes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sku_product_attributes" do
    field :sku_id, :binary_id
    field :product_attribute_id, :binary_id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [])
    |> validate_required([])
  end
end
