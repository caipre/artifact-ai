defmodule ArtifactAi.Commerce.OrderStatus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_states" do
    field :state, Ecto.Enum,
      values: [:PaymentDue, :Processing, :InTransit, :Delivered, :Problem, :Cancelled]

    field :order_id, :binary_id
    field :previous_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(order_status, attrs) do
    order_status
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
