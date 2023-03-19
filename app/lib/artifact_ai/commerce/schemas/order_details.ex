defmodule ArtifactAi.Commerce.OrderDetails do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_details" do
    field :external_id, :string
    field :shipping, :decimal
    field :tax, :decimal
    field :order_id, Ecto.UUID
    field :shipping_address_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(order_details, attrs) do
    order_details
    |> cast(attrs, [:external_id, :shipping, :tax])
    |> validate_required([:external_id, :shipping, :tax])
  end
end
