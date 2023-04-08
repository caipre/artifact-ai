defmodule ArtifactAiWeb.OrderLive.Payment do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Images
  alias ArtifactAi.Orders

  def mount(%{"id" => id} = _params, _session, socket) do
    #    https://stripe.com/docs/api/checkout/sessions/create
    with order <- Orders.from!(id),
         [item | _items] <- Orders.items(order),
         {:ok, session} <-
           Stripe.Session.create(%{
             client_reference_id: order.id,
             customer_email: socket.assigns.current_user.email,
             line_items: [
               %{
                 price_data: %{
                   product_data: %{
                     name: "Single Print",
                     description: item.prompt.prompt,
                     images: [Images.url(item.image)]
                   },
                   currency: "USD",
                   unit_amount: "100"
                 },
                 quantity: 1
               }
             ],
             mode: "payment",
             shipping_address_collection: %{
               allowed_countries: ["US"]
             },
             success_url: url(~p"/orders/#{id}/success")
           }) do
      {:ok, redirect(socket, external: session.url)}
    else
      error ->
        dbg(error)
        {:ok, socket}
    end
  end
end
