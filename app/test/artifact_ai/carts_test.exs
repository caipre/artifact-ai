defmodule ArtifactAi.CartsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.PromptsFixtures
  alias ArtifactAi.ProductsFixtures
  alias ArtifactAi.CartsFixtures

  alias ArtifactAi.Carts
  alias ArtifactAi.Commerce.Cart

  describe "carts" do
    test "create_cart/1 creates an empty cart" do
      user = AccountsFixtures.user_fixture()
      {:ok, %Cart{} = cart} = Carts.create_cart(user)
      assert Carts.empty?(cart)
    end

    test "add_cart_item/4 adds an item to a cart" do
      valid_attrs = %{
        quantity: 1
      }

      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      sku = ProductsFixtures.sku_fixture()
      offer = ProductsFixtures.offer_fixture(sku)
      cart = CartsFixtures.cart_fixture(user)

      Carts.add_cart_item(cart, offer, prompt, valid_attrs)
      assert !Carts.empty?(cart)
    end

    test "update_cart_item/2 returns error when quantity < 1" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      sku = ProductsFixtures.sku_fixture()
      offer = ProductsFixtures.offer_fixture(sku)
      cart = CartsFixtures.cart_fixture(user)
      cart_item = CartsFixtures.cart_item_fixture(cart, offer, prompt)

      assert {:error, _} = Carts.update_cart_item(cart_item, %{quantity: 0})
    end

    test "remove_cart_item/2 removes an item from a cart" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      sku = ProductsFixtures.sku_fixture()
      offer = ProductsFixtures.offer_fixture(sku)
      cart = CartsFixtures.cart_fixture(user)
      cart_item = CartsFixtures.cart_item_fixture(cart, offer, prompt)

      Carts.remove_cart_item(cart_item)
      assert Carts.empty?(cart)
    end
  end
end
