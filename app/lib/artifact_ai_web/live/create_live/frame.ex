defmodule ArtifactAiWeb.CreateLive.Frame do
  use ArtifactAiWeb, :live_view
  @moduledoc false

  def mount(%{"prompt" => prompt} = _params, _session, socket) do
    {:ok, assign(socket, :prompt, %{prompt: prompt, id: 123})}
  end
end
