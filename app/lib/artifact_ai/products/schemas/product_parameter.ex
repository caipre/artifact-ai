defmodule ArtifactAi.Products.ProductParameters do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product_parameters" do
    field :parameter, :string
    field :product_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(product_parameters, attrs) do
    product_parameters
    |> cast(attrs, [:parameter])
    |> validate_required([:parameter])
  end
end
