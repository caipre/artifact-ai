defmodule ArtifactAi.PromptsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures
  alias ArtifactAi.PromptsFixtures

  alias ArtifactAi.Prompts.Prompt
  alias ArtifactAi.Prompts

  describe "prompts" do
    test "list/0 returns all prompts" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      assert Prompts.list() == [prompt]
    end

    test "get!/1 returns the prompt with given id" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      assert Prompts.get!(prompt.id) == prompt
    end

    test "from!/1 returns a prompt by shortid" do
      user = AccountsFixtures.user_fixture()
      prompt = PromptsFixtures.prompt_fixture(user)
      assert Prompts.from!(shortid(prompt.id)) == prompt
    end

    test "create/2 with valid data creates a prompt" do
      user = AccountsFixtures.user_fixture()
      valid_attrs = %{prompt: "some prompt"}

      assert {:ok, %Prompt{} = prompt} = Prompts.create(user, valid_attrs)
      assert prompt.prompt == "some prompt"
    end

    test "create/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.create(user, %{})
    end
  end
end
