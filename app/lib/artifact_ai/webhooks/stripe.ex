defmodule ArtifactAi.Webhooks.Stripe do
  @moduledoc false

  alias ArtifactAi.Orders
  alias ArtifactAi.Addresses

  @behaviour Stripe.WebhookHandler

  @impl true
  def handle_event(%Stripe.Event{type: "checkout.session.completed", data: data} = event) do
    #    https://stripe.com/docs/api/checkout/sessions/object
    with %{object: session} <- data,
         {:ok, %{order: order}} <- Orders.from!(session.client_reference_id),
         {:ok, address} <- Addresses.create(order.user_id, session.shipping_details),
         {:ok, order_details} <-
           Orders.create_order_details(order, %{
             external_id: session.id,
             shipping: Decimal.new("0.00"),
             tax: Decimal.new("0.00")
           }) do
      :ok
    end
  end

  # Return HTTP 200 OK for unhandled events
  @impl true
  def handle_event(_event), do: :ok
end
