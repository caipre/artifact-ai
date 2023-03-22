defmodule ArtifactAiWeb.CreateLive.Show do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Images
  alias ArtifactAi.Prompts
  alias ArtifactAi.Carts

  def mount(%{"prompt" => prompt, "image" => image} = _params, _session, socket) do
    with prompt <- Prompts.from!(prompt),
         image <- Images.from!(image) do
      [^image | images] = Images.with_prompt_id(prompt.id)

      {:ok,
       assign(socket,
         form: nil,
         prompt: prompt,
         image: image,
         images: images
       )}
    end
  end

  def handle_event("submit", params, socket) do
    with {:ok, cart} <- Carts.create_cart(socket.assigns.current_user) do
      {:noreply, push_navigate(socket, to: ~p"/purchase/#{shortid(cart.id)}/payment")}
    end
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end
