defmodule ArtifactAi.Artifacts.ImagesTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.ImagesFixtures
  alias ArtifactAi.PromptsFixtures

  alias ArtifactAi.Artifacts.Image
  alias ArtifactAi.Images

  describe "images" do
    test "list/0 returns all images" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = ImagesFixtures.image_fixture(user, prompt)
      assert Enum.map(Images.list(), fn img -> img.id end) == [image.id]
    end

    test "get!/1 returns an image by id" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = ImagesFixtures.image_fixture(user, prompt)
      assert Images.get!(image.id) == image
    end

    test "from!/1 returns an image by shortid" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = ImagesFixtures.image_fixture(user, prompt)
      assert Images.from!(shortid(image.id)) == image
    end

    test "create/2 creates an image from a prompt" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      image = ImagesFixtures.image_fixture(user, prompt)
      valid_attrs = %{url: "https://example.org"}

      assert {:ok, %Image{} = image} = Images.create(user, prompt, valid_attrs)
      assert image.url == "https://example.org"
    end

    test "create/2 with invalid data returns an error" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Images.create(user, prompt, %{})
    end
  end
end
