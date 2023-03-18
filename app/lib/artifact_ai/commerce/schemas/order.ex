defmodule ArtifactAi.Commerce.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Commerce.Cart

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    belongs_to :user, User, type: Ecto.UUID
    belongs_to :cart, Cart, type: Ecto.UUID
    field :subtotal, :decimal

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:subtotal])
    |> validate_required([:subtotal])
    |> validate_number(:subtotal, greater_than: 0)
  end
end
