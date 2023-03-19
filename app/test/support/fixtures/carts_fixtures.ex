defmodule ArtifactAi.CartsFixtures do
  @moduledoc false

  alias ArtifactAi.Carts

  def cart_fixture(user) do
    {:ok, cart} = Carts.create_cart(user)
    cart
  end

  def cart_item_fixture(cart, offer, prompt, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        quantity: 1
      })

    {:ok, cart_item} = Carts.add_cart_item(cart, offer, prompt, attrs)
    cart_item
  end
end
