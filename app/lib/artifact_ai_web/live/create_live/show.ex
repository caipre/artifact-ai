defmodule ArtifactAiWeb.CreateLive.Show do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  def mount(%{"prompt" => prompt} = _params, _session, socket) do
    {:ok, assign(socket, prompt: %{prompt: prompt, id: 123}, image: %{id: 234})}
  end
end
