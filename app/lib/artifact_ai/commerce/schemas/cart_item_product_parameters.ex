defmodule ArtifactAi.Products.CartItemProductParameter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_item_product_parameters" do
    field :cart_item_id, :binary_id
    field :product_attribute_id, :binary_id
    field :value, :binary_id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [])
    |> validate_required([])
  end
end
