defmodule ArtifactAi.Orders do
  @moduledoc false
  alias ArtifactAi.Repo
  alias Ecto.Multi
  import Ecto.Query

  alias ArtifactAi.Accounts.Address
  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Orders.Orders
  alias ArtifactAi.Orders.Order
  alias ArtifactAi.Orders.OrderDetails

  def get!(id) do
    Repo.get!(Order, id)
  end

  def from!(shortid) do
    Repo.from!(Order, shortid)
  end

  def create_order(%User{} = user, attrs) do
    Ecto.build_assoc(user, :orders)
    |> Order.changeset(attrs)
    |> Repo.insert()
  end
end
