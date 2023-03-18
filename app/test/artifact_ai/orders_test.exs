defmodule ArtifactAi.OrdersTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.CartsFixtures
  alias ArtifactAi.ProductsFixtures
  alias ArtifactAi.PromptsFixtures
  alias ArtifactAi.OffersFixtures

  alias ArtifactAi.Orders
  alias ArtifactAi.Offers
  alias ArtifactAi.Commerce.Order

  describe "orders" do
    test "create_order/2 creates an order" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      sku = ProductsFixtures.sku_fixture()
      offer = OffersFixtures.offer_fixture(sku)
      cart = CartsFixtures.cart_fixture(user)
      cart_item = CartsFixtures.cart_item_fixture(cart, offer, prompt)

      assert {:ok, %Order{} = order} = Orders.create_order(cart)
      assert order.subtotal > 0
    end
  end
end
