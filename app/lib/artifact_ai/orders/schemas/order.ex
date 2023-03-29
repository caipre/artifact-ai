defmodule ArtifactAi.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Orders.OrderDetails
  alias ArtifactAi.Orders.OrderItem
  alias ArtifactAi.Orders.OrderState
  alias ArtifactAi.Orders.Payment

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "orders" do
    belongs_to :user, User, type: Ecto.UUID
    field :amount_subtotal, :integer

    has_many :items, OrderItem
    has_many :states, OrderState
    has_one :details, OrderDetails
    has_one :payment, Payment

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:amount_subtotal])
    |> validate_required([:amount_subtotal])
    |> validate_number(:amount_subtotal, greater_than: 0)
  end
end
