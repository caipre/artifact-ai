defmodule ArtifactAi.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Orders.Order
  alias ArtifactAi.Prompts.Prompt
  alias ArtifactAi.Artifacts.Image

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_items" do
    belongs_to :order, Order, type: Ecto.UUID
    belongs_to :prompt, Prompt, type: Ecto.UUID
    belongs_to :image, Image, type: Ecto.UUID
    field :quantity, :integer

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
    |> validate_number(:quantity, greater_than: 0)
  end
end
