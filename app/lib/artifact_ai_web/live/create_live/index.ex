defmodule ArtifactAiWeb.CreateLive.Index do
  use ArtifactAiWeb, :live_view

  alias ExAws.S3

  alias ArtifactAi.Images
  alias ArtifactAi.Prompts
  alias ArtifactAi.Prompts.Prompt

  @moduledoc false

  def mount(params, _session, socket) do
    changeset =
      socket.assigns.current_user
      |> Ecto.build_assoc(:prompts)
      |> Prompt.changeset(params)

    images = Images.list()

    {:ok, assign(socket, form: to_form(changeset), images: images)}
  end

  defp upload(url, id) do
    acc = {nil, [], []}

    fun = fn
      {:status, value}, {_, headers, body} -> {value, headers, body}
      {:headers, value}, {status, headers, body} -> {status, headers ++ value, body}
      {:data, value}, {status, headers, body} -> {status, headers, [value | body]}
    end

    with {:ok, {_status, _headers, body}} <-
           Finch.build(:get, url) |> Finch.stream(ArtifactAi.Finch, acc, fun) do
      data = body |> Enum.reverse() |> IO.iodata_to_binary()

      S3.put_object("dev-generated-images-4ed2", "image-#{id}.png", data,
        content_type: "image/png"
      )
      |> ExAws.request(region: "us-east-2")
    end
  end

  def handle_event("validate", %{"prompt" => params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Ecto.build_assoc(:prompts)
      |> Prompt.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("submit", %{"prompt" => params}, socket) do
    # todo: move this to a helper function
    with {:ok, result} <- OpenAI.Images.generate(params["prompt"], size: "1024x1024"),
         %{"data" => [%{"url" => url}]} <- result,
         {:ok, prompt} <- Prompts.create(socket.assigns.current_user, params),
         {:ok, image} <- Images.create(socket.assigns.current_user, prompt),
         {:ok, _} <- upload(url, image.id) do
      {:noreply, redirect(socket, to: ~p"/e/#{shortid(prompt.id)}/#{shortid(image.id)}")}
    else
      {:error, _error} ->
        {:noreply, socket}
    end
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end
