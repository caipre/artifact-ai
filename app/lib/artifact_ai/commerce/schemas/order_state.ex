defmodule ArtifactAi.Commerce.OrderState do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Commerce.OrderState

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_states" do
    belongs_to :order, Order, type: Ecto.UUID

    field :state, Ecto.Enum,
      values: [:PaymentDue, :Processing, :InTransit, :Delivered, :Problem, :Cancelled]

    has_one :previous, OrderState

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(order_status, attrs) do
    order_status
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
