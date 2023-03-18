defmodule ArtifactAi.PromptsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Artifacts.Prompts
  alias ArtifactAi.AccountsFixtures

  describe "prompts" do
    import ArtifactAi.PromptsFixtures

    @invalid_attrs %{prompt: nil}

    test "list/0 returns all prompts" do
      user = AccountsFixtures.user_fixture()
      prompt = prompt_fixture(user)
      assert Prompts.list() == [prompt]
    end

    test "get!/1 returns the prompt with given id" do
      user = AccountsFixtures.user_fixture()
      prompt = prompt_fixture(user)
      assert Prompts.get!(prompt.id) == prompt
    end

    test "create/1 with valid data creates a prompt" do
      user = AccountsFixtures.user_fixture()
      prompt = prompt_fixture(user)
      valid_attrs = %{prompt: "some prompt"}

      assert {:ok, %Prompt{} = prompt} = Prompts.create(valid_attrs, user)
      assert prompt.prompt == "some prompt"
    end

    test "create/1 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.create(@invalid_attrs, user)
    end
  end
end
