defmodule ArtifactAiWeb.CreateLive.Show do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  alias ArtifactAi.Artifacts.Images
  alias ArtifactAi.Artifacts.Prompts

  @doc """
  A prompt
  """
  def mount(%{"prompt" => prompt} = params, _session, socket) do
    with prompt <- Prompts.from!(prompt) do
      [image | images] = Images.with_prompt_id(prompt.id)

      {:ok,
       assign(socket,
         prompt: prompt,
         image: image,
         images: images
       )}
    end
  end

  @doc """
  A prompt and image pair
  """
  def mount(%{"prompt" => prompt, "image" => image} = params, _session, socket) do
    with prompt <- Prompts.from!(prompt),
         image <- Images.from!(image) do
      [image | images] = Images.with_prompt_id(prompt.id)

      {:ok,
       assign(socket,
         prompt: prompt,
         image: image,
         images: images
       )}
    end
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end
