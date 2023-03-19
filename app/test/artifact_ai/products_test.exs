defmodule ArtifactAi.ProductsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.ProductsFixtures

  alias ArtifactAi.Products
  alias ArtifactAi.Offers
  alias ArtifactAi.Products.Offer
  alias ArtifactAi.Products.Product
  alias ArtifactAi.Products.ProductAttribute
  alias ArtifactAi.Products.ProductParameter
  alias ArtifactAi.Products.Sku

  describe "products" do
    test "create_product/1 creates a product" do
      valid_attrs = %{
        name: "some product name",
        price: "21.34",
        currency: "USD"
      }

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == valid_attrs.name
      assert product.price == Decimal.new(valid_attrs.price)
      assert product.currency == valid_attrs.currency
    end

    test "create_attribute/1 creates an attribute" do
      product = ProductsFixtures.product_fixture()

      valid_attrs = %{
        name: "some attribute name",
        value: "some value",
        price: "1.23",
        currency: "USD"
      }

      assert {:ok, %ProductAttribute{} = attribute} =
               Products.create_attribute(product, valid_attrs)

      assert attribute.name == valid_attrs.name
      assert attribute.value == valid_attrs.value
      assert attribute.price == Decimal.new(valid_attrs.price)
      assert attribute.currency == valid_attrs.currency
    end

    test "create_parameter/1 creates a parameter" do
      product = ProductsFixtures.product_fixture()

      valid_attrs = %{
        name: "some parameter name"
      }

      assert {:ok, %ProductParameter{} = parameter} =
               Products.create_parameter(product, valid_attrs)

      assert parameter.name == valid_attrs.name
    end
  end

  describe "skus" do
    test "create_sku/2 creates a sku and attributes" do
      product = ProductsFixtures.product_fixture()
      attribute1 = ProductsFixtures.attribute_fixture(product, %{name: "attribute 1"})
      attribute2 = ProductsFixtures.attribute_fixture(product, %{name: "attribute 2"})

      assert {:ok, %Sku{} = _} = Products.create_sku(product, [attribute1, attribute2])
    end

    test "add_attribute/2 adds an attribute to a sku" do
      product = ProductsFixtures.product_fixture()
      attribute1 = ProductsFixtures.attribute_fixture(product, %{name: "attribute 1"})
      attribute2 = ProductsFixtures.attribute_fixture(product, %{name: "attribute 2"})

      {:ok, sku} = Products.create_sku(product, [attribute1])
      Products.add_sku_attribute(sku, attribute2)
    end

    test "get_sku/1 returns the sku and attributes" do
      sku = ProductsFixtures.sku_fixture()
      Products.get_sku(sku.id)
    end
  end

  describe "offers" do
    test "create_offer/2 creates a offer" do
      valid_attrs = %{
        price: "12.34",
        currency: "USD",
        expires_at: DateTime.utc_now() |> DateTime.add(1, :day) |> DateTime.truncate(:second)
      }

      sku = ProductsFixtures.sku_fixture()
      assert {:ok, %Offer{} = offer} = Offers.create_offer(sku, valid_attrs)
      assert offer.price == Decimal.new(valid_attrs.price)
      assert offer.currency == valid_attrs.currency
      assert offer.expires_at == valid_attrs.expires_at
    end
  end
end
