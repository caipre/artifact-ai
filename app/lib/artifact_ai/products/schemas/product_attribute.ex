defmodule ArtifactAi.Products.ProductAttributes do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product_attributes" do
    field :attribute, :string
    field :currency, :string
    field :price, :decimal
    field :value, :string
    field :product_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(product_attributes, attrs) do
    product_attributes
    |> cast(attrs, [:attribute, :value, :price, :currency])
    |> validate_required([:attribute, :value, :price, :currency])
  end
end
