defmodule ArtifactAi.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Artifacts.Images` context.
  """

  alias ArtifactAi.Images

  @doc """
  Generate a prompt.
  """
  def image_fixture(user, prompt, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        url: "https://example.org"
      })

    {:ok, image} = Images.create(user, prompt, attrs)

    image
  end
end
