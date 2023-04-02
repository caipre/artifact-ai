defmodule ArtifactAi.PromptsFixtures do
  @moduledoc false

  alias ArtifactAi.Prompts

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
