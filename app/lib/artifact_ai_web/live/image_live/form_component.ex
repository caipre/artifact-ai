defmodule ArtifactAiWeb.ImageLive.FormComponent do
  use ArtifactAiWeb, :live_component

  alias ArtifactAi.Images

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage image records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="image-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:url]} type="text" label="Url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Image</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{image: image} = assigns, socket) do
    changeset = Images.change_image(image)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"image" => image_params}, socket) do
    changeset =
      socket.assigns.image
      |> Images.change_image(image_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"image" => image_params}, socket) do
    save_image(socket, socket.assigns.action, image_params)
  end

  defp save_image(socket, :edit, image_params) do
    case Images.update_image(socket.assigns.image, image_params) do
      {:ok, image} ->
        notify_parent({:saved, image})

        {:noreply,
         socket
         |> put_flash(:info, "Image updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_image(socket, :new, image_params) do
    case Images.create_image(image_params) do
      {:ok, image} ->
        notify_parent({:saved, image})

        {:noreply,
         socket
         |> put_flash(:info, "Image created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
