defmodule ArtifactAi.ImagesTest do
  use ArtifactAi.DataCase

  alias ArtifactAi.Images

  describe "images" do
    alias ArtifactAi.Image

    import ArtifactAi.ImagesFixtures

    @invalid_attrs %{prompt: nil}

    test "list/0 returns all images" do
      image = image_fixture()
      assert Images.list() == [image]
    end

    test "get!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get!(image.id) == image
    end

    test "create/1 with valid data creates a image" do
      prompt = ArtifactAi.PromptsFixtures.prompt_fixture()
      valid_attrs = %{url: "https://example.org"}

      assert {:ok, %Image{} = image} = Images.create(valid_attrs, prompt)
      assert image.url == "https://example.org"
    end

    test "create/1 with invalid data returns error changeset" do
      prompt = ArtifactAi.PromptsFixtures.prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.create(@invalid_attrs, prompt)
    end
  end
end
