defmodule ArtifactAiWeb.OrderLive.Success do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Emails
  alias ArtifactAi.Orders

  def mount(%{"id" => id} = _params, _session, socket) do
    with order <- Orders.from!(id) |> Orders.preload(),
         [item | _items] <- Orders.items(order) do
      unless Orders.sent_confirmation_email?(order) do
        Emails.send_confirmation_email(socket.assigns.current_user, order)
        Orders.sent_confirmation_email(socket.assigns.current_user, order)
      end

      {:ok, assign(socket, order: order, image: item.image)}
    end
  end
end
