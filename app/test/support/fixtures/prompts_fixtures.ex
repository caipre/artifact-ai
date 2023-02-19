defmodule ArtifactAi.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Prompts` context.
  """

  import ArtifactAi.AccountsFixtures

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        prompt: "some prompt",
        user_id: user.id
      })
      |> ArtifactAi.Prompts.create_prompt()

    prompt
  end
end
