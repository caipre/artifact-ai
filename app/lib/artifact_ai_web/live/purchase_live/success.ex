defmodule ArtifactAiWeb.PurchaseLive.Success do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Orders

  def mount(%{"id" => id} = params, _session, socket) do
    with order <- Orders.from!(id) do
      {:ok, assign(socket, order: order)}
    end
  end
end
