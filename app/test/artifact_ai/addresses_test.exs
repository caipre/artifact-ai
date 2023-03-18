defmodule ArtifactAi.AddressesTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures

  alias ArtifactAi.Addresses

  describe "addresses" do
    test "create_address/2 creates an address" do
      valid_attrs = %{
        address1: "some street address",
        address2: "some apartment number",
        city: "some apartment number",
        region: "some state name",
        postcode: "12345",
        country: "US"
      }

      user = AccountsFixtures.user_fixture()

      {:ok, address} = Addresses.create(user, valid_attrs)
      assert address.address1 == valid_attrs.address1
      assert address.address2 == valid_attrs.address2
      assert address.city == valid_attrs.city
      assert address.region == valid_attrs.region
      assert address.postcode == valid_attrs.postcode
      assert address.country == valid_attrs.country
    end
  end
end
