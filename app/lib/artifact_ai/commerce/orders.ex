defmodule ArtifactAi.Orders do
  @moduledoc false
  import Ecto.Query
  alias ArtifactAi.Repo

  alias ArtifactAi.Carts
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Commerce.CartItem

  ## Orders

  def create_order(%Cart{} = cart) do
    subtotal = Carts.subtotal(cart)
    Ecto.build_assoc(cart, :order, user_id: cart.user_id)
    |> Order.changeset(%{subtotal: subtotal})
    |> Repo.insert()
  end
end
