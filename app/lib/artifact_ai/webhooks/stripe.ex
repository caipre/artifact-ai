defmodule ArtifactAi.Webhooks.Stripe do
  @moduledoc false
  alias ArtifactAi.Repo
  alias Ecto.Multi
  import Ecto.Query

  alias ArtifactAi.Accounts.Address
  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Orders.Order
  alias ArtifactAi.Orders.OrderDetails
  alias ArtifactAi.Orders.OrderState

  @behaviour Stripe.WebhookHandler

  @impl true
  def handle_event(
        %Stripe.Event{
          type: "checkout.session.completed",
          data: %{object: session}
        } = event
      ) do
    #    https://stripe.com/docs/api/checkout/sessions/object
    #    todo: should the multi be someplace else?
    Multi.new()
    |> Multi.one(:order, from(order in Order, where: order.id == ^session.client_reference_id))
    |> Multi.one(:user, fn %{order: order} ->
      from(user in User, where: user.id == ^order.user_id)
    end)
    |> Multi.insert(:address, fn %{user: user} ->
      Ecto.build_assoc(user, :addresses)
      |> Address.changeset(to_address(session.customer_details.address))
    end)
    |> Multi.insert(:details, fn %{order: order, address: address} ->
    dbg(address)
      Ecto.build_assoc(order, :details, shipping_address_id: address.id)
      |> OrderDetails.changeset(to_order_details(session))
    end)
    |> Multi.insert(:state, fn %{order: order} ->
      Ecto.build_assoc(order, :states)
      |> OrderState.changeset(%{state: :Processing})
    end)
    |> Repo.transaction()

    :ok
  end

  defp to_address(address) do
    %{
      address1: address.line1,
      address2: address.line2,
      city: address.city,
      region: address.state,
      postcode: address.postal_code,
      country: address.country
    }
  end

  defp to_order_details(session) do
    %{
      external_id: session.id,
      amount_shipping: session.total_details.amount_shipping,
      amount_tax: session.total_details.amount_tax,
      amount_total: session.amount_total
    }
  end

  # Return HTTP 200 OK for unhandled events
  @impl true
  def handle_event(_event), do: :ok
end
