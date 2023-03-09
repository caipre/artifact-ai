defmodule ArtifactAi.ImagesTest do
  use ArtifactAi.DataCase

  alias ArtifactAi.Images

  describe "images" do
    alias ArtifactAi.Image

    import ArtifactAi.ImagesFixtures

    @invalid_attrs %{prompt: nil}

    test "list/0 returns all images" do
      image = image_fixture()
      assert List.first(Images.list()).id == image.id
    end

    test "get!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get!(image.id) == image
    end

    test "create/1 with valid user data creates a image" do
      user = ArtifactAi.AccountsFixtures.user_fixture()
      valid_attrs = %{prompt: "some prompt", url: "https://example.org"}

      assert {:ok, multi} = Images.create(valid_attrs, user)
      assert multi.image.url == "https://example.org"
    end

    test "create/1 with valid prompt data creates a image" do
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
