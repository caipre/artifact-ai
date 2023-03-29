defmodule ArtifactAiWeb.PurchaseLive.Payment do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Orders

  def mount(%{"id" => id} = _params, session, socket) do
    with order <- Orders.from!(id),
         {:ok, session} <-
           Stripe.Session.create(%{
             #             cancel_url: url(~p"/e/#{shortid(prompt.id)}/#{shortid(image.id)}"),
             client_reference_id: order.id,
             customer_email: socket.assigns.current_user.email,
             line_items: [
               %{
                 # Single Print — Test mode
                 price: "price_1MnD0XBhYGMMCX9kxlJfC9P5",
                 quantity: 1
               }
             ],
             #             metadata: %{
             #               prompt_id: socket.assigns.prompt.id,
             #               image_id: socket.assigns.image.id
             #             },
             mode: "payment",
             shipping_address_collection: %{
               allowed_countries: ["US"]
             },
             success_url: url(~p"/purchase/#{id}/success")
           }) do
      {:ok, redirect(socket, external: session.url)}
    else
      error ->
        dbg(error)
        {:noreply, socket}
    end
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end
