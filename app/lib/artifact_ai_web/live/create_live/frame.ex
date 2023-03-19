defmodule ArtifactAiWeb.CreateLive.Frame do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Images
  alias ArtifactAi.Prompts

  def mount(%{"prompt" => prompt, "image" => image} = _params, _session, socket) do
    with prompt <- Prompts.from!(prompt),
         image <- Images.from!(image) do
      [^image | images] = Images.with_prompt_id(prompt.id)

      {:ok,
       assign(socket,
         prompt: prompt,
         image: image,
         images: images
       )}
    end
  end

  def handle_event("validate", %{"frame" => _params}, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", %{"frame" => _params}, socket) do
    {:noreply, socket}
  end
end
