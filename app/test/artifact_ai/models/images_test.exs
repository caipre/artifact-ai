defmodule ArtifactAi.ImagesTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.Artifacts.Images
  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.PromptsFixtures

  describe "images" do
    import ArtifactAi.ImagesFixtures

    @invalid_attrs %{prompt: nil}

    test "list/0 returns all images" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = image_fixture(prompt)
      assert List.first(Images.list()).id == image.id
    end

    test "get!/1 returns the image with given id" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = image_fixture(prompt)
      assert Images.get!(image.id) == image
    end

    test "create/1 with valid user data creates a image" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = image_fixture(prompt)
      valid_attrs = %{prompt: "some prompt", url: "https://example.org"}

      assert {:ok, multi} = Images.create(valid_attrs, user)
      assert multi.image.url == "https://example.org"
    end

    test "create/1 with valid prompt data creates a image" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = image_fixture(prompt)
      valid_attrs = %{url: "https://example.org"}

      assert {:ok, %Image{} = image} = Images.create(valid_attrs, prompt)
      assert image.url == "https://example.org"
    end

    test "create/1 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Images.create(@invalid_attrs, prompt)
    end
  end
end
