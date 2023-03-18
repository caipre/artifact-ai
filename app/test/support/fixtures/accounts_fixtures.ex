defmodule ArtifactAi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Accounts` context.
  """

  alias ArtifactAi.Accounts

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        email: "email@example.org",
        image: "some image",
        name: "some name",
        iss: "some iss"
      })

    {:ok, user} = Accounts.create_user(attrs)

    user
  end
end
