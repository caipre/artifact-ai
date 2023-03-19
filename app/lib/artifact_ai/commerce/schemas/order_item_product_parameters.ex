defmodule ArtifactAi.Products.OrderItemProductParameter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_item_product_parameters" do
    field :order_item_id, Ecto.UUID
    field :product_parameter_id, Ecto.UUID
    field :value, Ecto.UUID

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [])
    |> validate_required([])
  end
end
