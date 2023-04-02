defmodule ArtifactAi.Orders do
  @moduledoc false
  alias ArtifactAi.Repo
  alias Ecto.Multi
  import Ecto.Query

  alias ArtifactAi.Accounts.Address
  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Orders.Order
  alias ArtifactAi.Orders.OrderDetails
  alias ArtifactAi.Orders.Orders

  def get!(id) do
    Repo.get!(Order, id)
  end

  def from!(shortid) do
    Repo.from!(Order, shortid)
  end

  def preload(order) do
    Repo.preload(order, [:items, :details, :states])
  end

  def create_order(%User{} = user, attrs) do
    Ecto.build_assoc(user, :orders)
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def image(%Order{} = order) do
    %Image{url: "https://picsum.photos/200"}
  end
end
