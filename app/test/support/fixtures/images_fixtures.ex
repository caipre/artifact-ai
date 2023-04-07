defmodule ArtifactAi.ImagesFixtures do
  @moduledoc false

  alias ArtifactAi.Images

  def image_fixture(user, prompt, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{})

    {:ok, image} = Images.create(user, prompt, attrs)

    image
  end
end
