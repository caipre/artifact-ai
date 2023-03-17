defmodule ArtifactAi.Commerce.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount, :decimal
    field :currency, :string
    field :external_id, :string
    field :order_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :currency, :external_id])
    |> validate_required([:amount, :currency, :external_id])
  end
end
