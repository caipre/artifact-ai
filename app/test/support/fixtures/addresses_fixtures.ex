defmodule ArtifactAi.AddressesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArtifactAi.Addresses` context.
  """

  @doc """
  Generate an address.
  """
  def address_fixture(user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        address1: "722 Olive Street",
        address2: "Apt 12",
        city: "Brooklyn",
        region: "New York",
        postcode: "10016",
        country: "US"
      })

    {:ok, address} = Addresses.create(user, attrs)

    address
  end
end
