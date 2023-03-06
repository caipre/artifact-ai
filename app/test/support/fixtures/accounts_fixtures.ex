defmodule ArtifactAi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "email@example.org",
        image: "some image",
        name: "some name",
        iss: "some iss"
      })
      |> ArtifactAi.Accounts.create_user()

    user
  end
end
