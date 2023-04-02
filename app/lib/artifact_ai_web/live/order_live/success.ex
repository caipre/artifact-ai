defmodule ArtifactAiWeb.OrderLive.Success do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Orders

  def mount(%{"id" => id} = _params, _session, socket) do
    with order <- Orders.from!(id) |> Orders.preload(),
         [item | _items] <- Orders.items(order) do
      {:ok, assign(socket, order: order, image: item.image)}
    end
  end
end
