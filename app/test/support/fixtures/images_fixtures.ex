defmodule ArtifactAi.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Images` context.
  """

  @doc """
  Generate a prompt.
  """
  def image_fixture(attrs \\ %{}) do
    prompt = ArtifactAi.PromptsFixtures.prompt_fixture()

    {:ok, image} =
      attrs
      |> Enum.into(%{
        url: "https://example.org"
      })
      |> ArtifactAi.Images.create(prompt)

    image
  end
end
