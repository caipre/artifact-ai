defmodule ArtifactAi.Orders.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Orders.Order

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "payments" do
    belongs_to :order, Order, type: Ecto.UUID
    field :external_id, :string
    field :amount, :decimal
    field :currency, :string

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :currency, :external_id])
    |> validate_required([:amount, :currency, :external_id])
  end
end
