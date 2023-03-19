defmodule ArtifactAi.Commerce.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Commerce.OrderItem
  alias ArtifactAi.Commerce.Payment
  alias ArtifactAi.Commerce.OrderDetails
  alias ArtifactAi.Commerce.OrderState

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "orders" do
    belongs_to :user, User, type: Ecto.UUID
    belongs_to :cart, Cart, type: Ecto.UUID
    field :subtotal, :decimal

    has_many :items, OrderItem
    has_many :states, OrderState
    has_one :payment, Payment
    has_one :details, OrderDetails

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:subtotal])
    |> validate_required([:subtotal])
    |> validate_number(:subtotal, greater_than: 0)
  end
end
