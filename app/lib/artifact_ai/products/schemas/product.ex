defmodule ArtifactAi.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Products.ProductAttribute
  alias ArtifactAi.Products.ProductParameter
  alias ArtifactAi.Products.Sku

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :price, :decimal
    field :currency, :string

    has_many :attributes, ProductAttribute
    has_many :parameters, ProductParameter
    has_many :skus, Sku

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :currency])
    |> validate_required([:name, :price, :currency])
  end
end
