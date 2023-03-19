defmodule ArtifactAi.Orders do
  @moduledoc false
  import Ecto.Query
  alias ArtifactAi.Repo
  alias Ecto.Multi

  alias ArtifactAi.Carts
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Commerce.CartItem
  alias ArtifactAi.Commerce.OrderItem
  alias ArtifactAi.Commerce.OrderState

  ## Orders

  def create_order(%Cart{} = cart) do
    Multi.new()
    |> Multi.run(:subtotal, fn _, _ ->
      {:ok, Carts.subtotal(cart)}
    end)
    |> Multi.insert(:order, fn %{subtotal: subtotal} ->
      Ecto.build_assoc(cart, :order, user_id: cart.user_id)
      |> Order.changeset(%{subtotal: subtotal})
    end)
    |> Multi.insert_all(:order_items, OrderItem, fn %{order: order} ->
      to_order_item_query(cart, order)
    end)
    |> Multi.insert(:order_state, fn %{order: order} ->
      Ecto.build_assoc(order, :states)
      |> OrderState.changeset(%{state: :PaymentDue})
    end)
    |> Repo.transaction()
  end

  defp to_order_item_query(%Cart{} = cart, %Order{} = order) do
    query =
      from item in CartItem,
        where: item.cart_id == ^cart.id,
        select: %{
          id: ^Ecto.UUID.bingenerate(),
          order_id: type(^order.id, :binary_id),
          offer_id: item.offer_id,
          prompt_id: item.prompt_id,
          quantity: item.quantity
        }

    query
  end

  def current_state_query(%Order{} = order) do
    query =
      from o in Order,
        join: s in assoc(o, :states),
        where: o.id == ^order.id

    query |> last(:inserted_at)
  end
end
