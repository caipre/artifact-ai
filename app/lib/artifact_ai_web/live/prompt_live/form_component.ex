defmodule ArtifactAiWeb.PromptLive.FormComponent do
  use ArtifactAiWeb, :live_component

  alias ArtifactAi.Images
  alias ArtifactAi.Prompts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage prompt records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="prompt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:prompt]} type="text" label="Prompt" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Prompt</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prompt: prompt} = assigns, socket) do
    changeset = Prompts.change_prompt(prompt)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"prompt" => prompt_params}, socket) do
    changeset =
      socket.assigns.prompt
      |> Prompts.change_prompt(prompt_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"prompt" => prompt_params}, socket) do
    save_prompt(socket, socket.assigns.action, prompt_params)
  end

  defp save_prompt(socket, :edit, prompt_params) do
    case Prompts.update_prompt(socket.assigns.prompt, prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_prompt(socket, :new, prompt_params) do
    case Prompts.create_prompt(Map.merge(%{"user_id" => socket.assigns.user.id}, prompt_params)) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        case Images.create_image_from_prompt(prompt) do
          {:ok, image} ->
            {:noreply,
             socket
             |> put_flash(:info, "Prompt created successfully.")
             |> put_flash(:info, "Image created at #{image.url}}.")
             |> push_patch(to: socket.assigns.patch)}

          error ->
            {:noreply,
             socket
             |> put_flash(:error, "Error #{error}}")
             |> push_patch(to: socket.assigns.patch)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
