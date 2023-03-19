defmodule ArtifactAi.Commerce.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Products.Offer
  alias ArtifactAi.Commerce.CartItemProductParameter

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "cart_items" do
    belongs_to :cart, Cart, type: Ecto.UUID
    belongs_to :offer, Offer, type: Ecto.UUID
    belongs_to :prompt, Prompt, type: Ecto.UUID
    field :quantity, :integer

    has_many :parameters, CartItemProductParameter

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
