defmodule ArtifactAi.Orders do
  @moduledoc false
  alias ArtifactAi.Repo
  alias Ecto.Multi
  import Ecto.Query

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Orders.Order
  alias ArtifactAi.Orders.OrderItem

  def get!(id) do
    Repo.get!(Order, id)
  end

  def from!(shortid) do
    Repo.from!(Order, shortid)
  end

  def preload(order) do
    Repo.preload(order, [:items, :details, :states])
  end

  def create_order(%User{} = user, %Image{} = image, attrs) do
    {:ok, %{order: order} = _multi} = create_order_multi(user, image, attrs)
    {:ok, order}
  end

  def create_order_multi(%User{} = user, %Image{} = image, attrs) do
    Multi.new()
    |> Multi.insert(
      :order,
      Ecto.build_assoc(user, :orders)
      |> Order.changeset(attrs)
    )
    |> Multi.insert(:item, fn %{order: order} ->
      Ecto.build_assoc(order, :items, prompt_id: image.prompt_id, image_id: image.id)
      |> OrderItem.changeset(attrs)
    end)
    |> Multi.insert(:state, fn %{order: order} ->
      Ecto.build_assoc(order, :states, state: :PaymentDue)
    end)
    |> Repo.transaction()
  end

  def items(%Order{} = order) do
    query =
      from i in OrderItem,
        where: i.order_id == ^order.id,
        preload: [:image, :prompt]

    Repo.all(query)
  end
end
