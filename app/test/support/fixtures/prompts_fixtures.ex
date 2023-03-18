defmodule ArtifactAi.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Prompts` context.
  """

  alias ArtifactAi.Prompts

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        prompt: "some prompt"
      })

    {:ok, prompt} = Prompts.create(user, attrs)

    prompt
  end
end
