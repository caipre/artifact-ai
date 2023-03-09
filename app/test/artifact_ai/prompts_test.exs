defmodule ArtifactAi.PromptsTest do
  use ArtifactAi.DataCase

  alias ArtifactAi.Prompts

  describe "prompts" do
    alias ArtifactAi.Prompt

    import ArtifactAi.PromptsFixtures

    @invalid_attrs %{prompt: nil}

    test "list/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Prompts.list() == [prompt]
    end

    test "get!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Prompts.get!(prompt.id) == prompt
    end

    test "create/1 with valid data creates a prompt" do
      user = ArtifactAi.AccountsFixtures.user_fixture()
      valid_attrs = %{prompt: "some prompt"}

      assert {:ok, %Prompt{} = prompt} = Prompts.create(valid_attrs, user)
      assert prompt.prompt == "some prompt"
    end

    test "create/1 with invalid data returns error changeset" do
      user = ArtifactAi.AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.create(@invalid_attrs, user)
    end
  end
end
