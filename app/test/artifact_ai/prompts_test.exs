defmodule ArtifactAi.PromptsTest do
  use ArtifactAi.DataCase

  alias ArtifactAi.Prompts

  describe "prompts" do
    alias ArtifactAi.Prompts.Prompt

    import ArtifactAi.PromptsFixtures

    @invalid_attrs %{prompt: nil}

    test "list_prompts/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Prompts.list_prompts() == [prompt]
    end

    test "get_prompt!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Prompts.get_prompt!(prompt.id) == prompt
    end

    test "create_prompt/1 with valid data creates a prompt" do
      user = ArtifactAi.AccountsFixtures.user_fixture()
      valid_attrs = %{prompt: "some prompt", user_id: user.id}

      assert {:ok, %Prompt{} = prompt} = Prompts.create_prompt(valid_attrs)
      assert prompt.prompt == "some prompt"
    end

    test "create_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prompts.create_prompt(@invalid_attrs)
    end
  end
end
