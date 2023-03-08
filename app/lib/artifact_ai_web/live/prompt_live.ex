defmodule ArtifactAiWeb.PromptLive do
  use ArtifactAiWeb, :live_view

  alias ArtifactAi.Prompts

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="submit">
      <.input field={@form[:prompt]} label="Enter a detailed description" required />
      <:actions>
        <.button phx-disable-with="Working...">Generate</.button>
      </:actions>
    </.simple_form>

    <.table id="prompts" rows={@prompts}>
      <:col :let={prompt} label="id"><%= prompt.id %></:col>
      <:col :let={prompt} label="user_id"><%= prompt.user_id %></:col>
      <:col :let={prompt} label="prompt"><%= prompt.prompt %></:col>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    prompts = Prompts.list_prompts()
    {:ok, assign(socket, form: to_form(%{}, as: "prompt"), prompts: prompts)}
  end

  def handle_event("submit", %{"prompt" => prompt} = _metadata, socket) do
    case Prompts.create_prompt(Map.put(prompt, "user_id", socket.assigns.current_user.id)) do
      {:ok, prompt} -> {:noreply, put_flash(socket, :info, "Inserted prompt.id=#{prompt.id}")}
      {:error, _changeset} -> {:noreply, put_flash(socket, :error, "Error inserting prompt.")}
    end
  end

  def handle_event(_event, _metadata, socket) do
    {:noreply, socket}
  end
end
