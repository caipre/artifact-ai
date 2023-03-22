defmodule ArtifactAi.Commerce.OrderDetails do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Accounts.Address

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_details" do
    belongs_to :order, Order, type: Ecto.UUID
    belongs_to :shipping_address, Address, type: Ecto.UUID
    field :external_id, :string
    field :shipping, :decimal
    field :tax, :decimal

    timestamps()
  end

  @doc false
  def changeset(order_details, attrs) do
    order_details
    |> cast(attrs, [:external_id, :shipping, :tax])
    |> validate_required([:external_id, :shipping, :tax])
  end
end
