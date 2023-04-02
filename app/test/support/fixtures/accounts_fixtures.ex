defmodule ArtifactAi.AccountsFixtures do
  @moduledoc false

  alias ArtifactAi.Accounts

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
