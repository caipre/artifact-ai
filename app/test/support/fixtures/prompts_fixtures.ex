defmodule ArtifactAi.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Prompts` context.
  """

  alias ArtifactAi.AccountsFixtures

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        prompt: "some prompt",
        user_id: user.id
      })
      |> ArtifactAi.Prompts.create(user)

    prompt
  end
end
