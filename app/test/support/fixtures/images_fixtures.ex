defmodule ArtifactAi.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Images` context.
  """

  alias ArtifactAi.Artifacts.Images

  @doc """
  Generate a prompt.
  """
  def image_fixture(prompt, attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        url: "https://example.org"
      })
      |> Images.create(prompt)

    image
  end
end
