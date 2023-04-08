defmodule ArtifactAiWeb.CreateLive.Show do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Images
  alias ArtifactAi.Prompts
  alias ArtifactAi.Orders

  def mount(%{"prompt" => prompt, "image" => image} = _params, _session, socket) do
    with prompt <- Prompts.from!(prompt),
         image <- Images.from!(image) do
      {:ok,
       assign(socket,
         form: nil,
         prompt: prompt,
         image: image,
         images: []
       )}
    end
  end

  def handle_event("submit", _params, socket) do
    # todo: replace with actual values
    attrs = %{amount_subtotal: 100, quantity: 1}

    with {:ok, order} <-
           Orders.create_order(socket.assigns.current_user, socket.assigns.image, attrs) do
      {:noreply, push_navigate(socket, to: ~p"/orders/#{shortid(order.id)}/payment")}
    else
      {:error, _error} ->
        {:noreply, socket}
    end
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end
