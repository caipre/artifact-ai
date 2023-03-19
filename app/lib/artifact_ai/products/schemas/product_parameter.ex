defmodule ArtifactAi.Products.ProductParameter do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Products.Product

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "product_parameters" do
    belongs_to :product, Product, type: Ecto.UUID
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(product_parameters, attrs) do
    product_parameters
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
