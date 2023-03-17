defmodule ArtifactAi.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Prompts` context.
  """

  alias ArtifactAi.Artifacts.Prompts

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(user, attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        prompt: "some prompt"
      })
      |> Prompts.create(user)

    prompt
  end
end
