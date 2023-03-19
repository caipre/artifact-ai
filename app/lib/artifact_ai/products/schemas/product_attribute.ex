defmodule ArtifactAi.Products.ProductAttribute do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Products.Product

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "product_attributes" do
    belongs_to :product, Product, type: Ecto.UUID
    field :name, :string
    field :value, :string
    field :price, :decimal
    field :currency, :string

    timestamps()
  end

  @doc false
  def changeset(product_attributes, attrs) do
    product_attributes
    |> cast(attrs, [:name, :value, :price, :currency])
    |> validate_required([:name, :value, :price, :currency])
  end
end
