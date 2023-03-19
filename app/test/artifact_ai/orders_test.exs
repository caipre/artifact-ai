defmodule ArtifactAi.OrdersTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.CartsFixtures
  alias ArtifactAi.ProductsFixtures
  alias ArtifactAi.PromptsFixtures
  alias ArtifactAi.OffersFixtures

  alias ArtifactAi.Carts
  alias ArtifactAi.Orders

  describe "orders" do
    test "create_order/2 creates an order from a cart" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      sku = ProductsFixtures.sku_fixture()
      offer = OffersFixtures.offer_fixture(sku)
      cart = CartsFixtures.cart_fixture(user)
      CartsFixtures.cart_item_fixture(cart, offer, prompt)

      assert {:ok, %{order: order, order_state: order_state} = _multi} = Orders.create_order(cart)

      assert order.subtotal == Carts.subtotal(cart)
      assert order_state.state == :PaymentDue
    end
  end
end
