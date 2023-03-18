defmodule ArtifactAi.Products do
  @moduledoc false
  import Ecto.Query
  alias ArtifactAi.Repo
  alias Ecto.Multi

  alias ArtifactAi.Products.Offer
  alias ArtifactAi.Products.Product
  alias ArtifactAi.Products.ProductAttribute
  alias ArtifactAi.Products.ProductParameter
  alias ArtifactAi.Products.Sku
  alias ArtifactAi.Products.SkuProductAttribute

  ## Products, Attributes, Parameters

  def create_product(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def create_attribute(%Product{} = product, attrs) do
    Ecto.build_assoc(product, :attributes)
    |> ProductAttribute.changeset(attrs)
    |> Repo.insert()
  end

  def create_parameter(%Product{} = product, attrs) do
    Ecto.build_assoc(product, :parameters)
    |> ProductParameter.changeset(attrs)
    |> Repo.insert()
  end

  ## SKUs
  def create_sku(%Product{} = product, attributes) when is_list(attributes) do
    case create_sku_multi(product, attributes) do
      {:ok, %{sku: sku}} ->
        {:ok, sku}

      {:error, error} ->
        {:error, error}
    end
  end

  defp create_sku_multi(%Product{} = product, attributes) when is_list(attributes) do
    Multi.new()
    |> Multi.insert(:sku, Ecto.build_assoc(product, :skus))
    |> Multi.insert_all(:attributes, SkuProductAttribute, fn %{sku: sku} ->
      attributes
      |> Enum.map(fn attribute ->
        %{sku_id: sku.id, product_attribute_id: attribute.id}
      end)
    end)
    |> Repo.transaction()
  end

  def add_sku_attribute(%Sku{} = sku, %ProductAttribute{} = attribute) do
    %SkuProductAttribute{sku_id: sku.id, product_attribute_id: attribute.id}
    |> Repo.insert()
  end

  def get_sku(id) do
    query =
      from sku in Sku,
        join: a in assoc(sku, :attributes),
        where: sku.id == ^id,
        group_by: sku.id,
        preload: :attributes

    Repo.all(query)
  end

  ## Offers

  def create_offer(%Sku{} = sku, attrs) do
    Ecto.build_assoc(sku, :offers)
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end
end
