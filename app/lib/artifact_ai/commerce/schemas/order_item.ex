defmodule ArtifactAi.Commerce.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Products.Offer
  alias ArtifactAi.Products.OrderItemProductParameter

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_items" do
    belongs_to :order, Order, type: Ecto.UUID
    belongs_to :offer, Offer, type: Ecto.UUID
    belongs_to :prompt, Prompt, type: Ecto.UUID
    field :quantity, :integer

    has_many :parameters, OrderItemProductParameter

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
    |> validate_number(:quantity, greater_than: 0)
  end
end
