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

  def from!(id) do
    query =
      from i in Cart,
        where: like(type(i.id, :string), ^"#{id}%")

    Repo.one!(query)
  end

  def cart_items_query(%Cart{} = cart) do
    from item in CartItem,
      where: item.cart_id == ^cart.id
  end

  def cart_item_parameters_query(%Cart{} = cart) do
    from item in CartItem,
      where: item.cart_id == ^cart.id,
      join: i in assoc(item, :parameters)
  end

  def get_cart_items(%Cart{} = cart) do
    Repo.all(cart_items_query(cart))
  end

  def empty?(%Cart{} = cart) do
    query = cart_items_query(cart) |> limit(1)
    !Repo.exists?(query)
  end

  def subtotal(%Cart{} = cart) do
    Decimal.new("20.00")
    #    query =
    #      from item in cart_items_query(cart),
    #        join: o in assoc(item, :offer),
    #        select: o.price
    #
    #    Repo.all(query)
    #    |> Enum.reduce(fn price, acc -> Decimal.add(price, acc) end)
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
