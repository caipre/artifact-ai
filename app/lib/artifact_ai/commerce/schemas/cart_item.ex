defmodule ArtifactAi.Commerce.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Commerce.Offer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cart_items" do
    belongs_to :cart, Cart, type: Ecto.UUID
    belongs_to :offer, Offer, type: Ecto.UUID
    belongs_to :prompt, Prompt, type: Ecto.UUID
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
    |> validate_number(:quantity, greater_than: 0)
  end
end
