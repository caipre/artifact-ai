defmodule ArtifactAi.Commerce.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Products.Offer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_items" do
    belongs_to :order, Order, type: Ecto.UUID
    belongs_to :offer, Offer, type: Ecto.UUID
    belongs_to :prompt, Prompt, type: Ecto.UUID
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
