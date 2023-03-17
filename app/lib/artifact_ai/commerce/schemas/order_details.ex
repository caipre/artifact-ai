defmodule ArtifactAi.Commerce.OrderDetails do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_details" do
    field :external_id, :string
    field :shipping, :decimal
    field :tax, :decimal
    field :order_id, :binary_id
    field :shipping_address_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(order_details, attrs) do
    order_details
    |> cast(attrs, [:external_id, :shipping, :tax])
    |> validate_required([:external_id, :shipping, :tax])
  end
end
