defmodule ArtifactAiWeb.CreateLive.Frame do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Images
  alias ArtifactAi.Products
  alias ArtifactAi.Prompts

  def mount(%{"prompt" => prompt, "image" => image} = params, _session, socket) do
    with prompt <- Prompts.from!(prompt),
         image <- Images.from!(image) do
      [image | images] = Images.with_prompt_id(prompt.id)

      changeset = Products.frame()

      {:ok,
       assign(socket,
         form: to_form(changeset),
         prompt: prompt,
         image: image,
         images: images
       )}
    end
  end

  def handle_event("validate", %{"frame" => params}, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", %{"frame" => params}, socket) do
    {:noreply, socket}
  end
end
