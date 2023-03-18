defmodule ArtifactAi.Carts do
  @moduledoc false
  import Ecto.Query
  alias ArtifactAi.Repo

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Commerce.Cart
  alias ArtifactAi.Commerce.CartItem
  alias ArtifactAi.Products.Offer

  ## Carts

  def empty?(%Cart{} = cart) do
    query =
      from ci in CartItem,
        where: ci.cart_id == ^cart.id,
        limit: 1

    !Repo.exists?(query)
  end

  def subtotal(%Cart{} = cart) do
     query = from i in CartItem,
                   where: i.cart_id == ^cart.id,
                   join: o in assoc(i, :offer),
                   select: o.price
     Repo.all(query)
     |> Enum.reduce(fn price, acc ->
       Decimal.add(price, acc)
     end)
  end

  def create_cart(%User{} = user) do
    Ecto.build_assoc(user, :carts)
    |> Repo.insert()
  end

  def add_cart_item(%Cart{} = cart, %Offer{} = offer, %Prompt{} = prompt, attrs) do
    Ecto.build_assoc(cart, :items, offer_id: offer.id, prompt_id: prompt.id)
    |> CartItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  def remove_cart_item(%CartItem{} = cart_item) do
    Repo.delete(cart_item)
  end
end
