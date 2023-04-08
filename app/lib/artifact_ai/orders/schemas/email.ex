defmodule ArtifactAi.Orders.Email do
  use Ecto.Schema

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Orders.Order

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_emails" do
    belongs_to :user, User, type: Ecto.UUID
    belongs_to :order, Order, type: Ecto.UUID

    timestamps(updated_at: false)
  end
end
