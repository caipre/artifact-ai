defmodule ArtifactAi.OrdersTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.PromptsFixtures

  alias ArtifactAi.Orders
  alias ArtifactAi.Orders.Order

  describe "orders" do
    test "create_order/2 creates an order" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = ArtifactAi.ImagesFixtures.image_fixture(user, prompt)
      valid_attrs = %{amount_subtotal: 100, quantity: 1}

      assert {:ok, %Order{} = order} = Orders.create_order(user, image, valid_attrs)
      assert order.amount_subtotal == valid_attrs.amount_subtotal
    end
  end
end
