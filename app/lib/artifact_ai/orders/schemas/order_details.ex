defmodule ArtifactAi.Orders.OrderDetails do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.Address
  alias ArtifactAi.Orders.Order

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_details" do
    belongs_to :order, Order, type: Ecto.UUID
    belongs_to :shipping_address, Address, type: Ecto.UUID
    field :external_id, :string
    field :amount_shipping, :integer
    field :amount_tax, :integer
    field :amount_total, :integer

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(order_details, attrs) do
    order_details
    |> cast(attrs, [:external_id, :amount_shipping, :amount_tax, :amount_total])
    |> validate_required([:external_id, :amount_shipping, :amount_tax, :amount_total])
  end
end
