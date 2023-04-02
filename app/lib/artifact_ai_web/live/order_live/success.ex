defmodule ArtifactAiWeb.OrderLive.Success do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Orders

  def mount(%{"id" => id} = params, _session, socket) do
    with order <- Orders.from!(id) |> Orders.preload(),
         image <- Orders.image(order) do
      {:ok, assign(socket, order: order, image: image)}
    end
  end
end
