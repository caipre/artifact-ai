defmodule ArtifactAi.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Images` context.
  """

  import ArtifactAi.PromptsFixtures

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    prompt = prompt_fixture()

    {:ok, image} =
      attrs
      |> Enum.into(%{
        url: "some url",
        user_id: prompt.user_id,
        prompt_id: prompt.id
      })
      |> ArtifactAi.Images.create_image()

    image
  end
end
