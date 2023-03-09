defmodule ArtifactAiWeb.PromptLive do
  use ArtifactAiWeb, :live_view

  alias ArtifactAi.Images
  alias ArtifactAi.Prompts

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-submit="submit">
      <.input field={@form[:prompt]} label="Enter a detailed description" required />
      <:actions>
        <.button phx-disable-with="Working...">Generate</.button>
      </:actions>
    </.simple_form>

    <.table id="images" rows={@images}>
      <:col :let={image} label="Prompt"><%= image.prompt.prompt %></:col>
      <:col :let={image} label="Image"><img src={image.url} /></:col>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "prompt"), images: Images.list())}
  end

  def handle_event("submit", %{"prompt" => params} = _metadata, socket) do
    with {:ok, result} <- OpenAI.Images.generate(params["prompt"], size: "1024x1024"),
         %{"data" => [%{"url" => url}]} <- result,
         {:ok, multi} <- Images.create(Map.put(params, "url", url), socket.assigns.current_user) do
      {:noreply, assign(socket, images: Images.list())}
    else
      {:error, error} ->
        {:noreply, socket}
    end
  end
end
