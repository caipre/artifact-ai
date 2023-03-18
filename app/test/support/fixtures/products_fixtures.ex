defmodule ArtifactAi.ProductsFixtures do
  @moduledoc false

  alias ArtifactAi.Products

  def product_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some product name",
        price: "21.34",
        currency: "USD"
      })

    {:ok, product} = Products.create_product(attrs)

    product
  end

  def attribute_fixture(product, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some attribute name",
        value: "some value",
        price: "1.23",
        currency: "USD"
      })

    {:ok, product} = Products.create_attribute(product, attrs)

    product
  end

  def sku_fixture() do
    product = product_fixture()
    attribute1 = attribute_fixture(product, %{name: "attribute 1"})
    attribute2 = attribute_fixture(product, %{name: "attribute 2"})
    {:ok, sku} = Products.create_sku(product, [attribute1, attribute2])
    sku
  end

  def offer_fixture(sku, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        price: "12.34",
        currency: "USD",
        expires_at: DateTime.utc_now() |> DateTime.add(1, :day) |> DateTime.truncate(:second)
      })

    {:ok, offer} = Products.create_offer(sku, attrs)
    offer
  end
end
