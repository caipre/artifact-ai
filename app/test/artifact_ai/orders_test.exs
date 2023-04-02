defmodule ArtifactAi.OrdersTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.ProductsFixtures
  alias ArtifactAi.PromptsFixtures

  alias ArtifactAi.Orders

  describe "orders" do
    test "create_order/2 creates an order" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)

      assert {:ok, %{order: order, order_state: order_state} = _multi} = Orders.create_order()

      assert order_state.state == :PaymentDue
    end
  end
end
