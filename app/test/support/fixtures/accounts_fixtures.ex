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
    {:ok, %{user: user}} =
      attrs
      |> Enum.into(%{
        email: "email@example.org",
        image: "some image",
        name: "some name",
        iss: "some iss"
      })
      |> Accounts.create_user()

    user
  end

  @doc """
  Generate an address.
  """
  def address_fixture(user, attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        address1: "722 Olive Street",
        address2: "Apt 12",
        city: "Brooklyn",
        region: "New York",
        postcode: "10016",
        country: "US"
      })
      |> Accounts.create_address(user)

    address
  end
end
