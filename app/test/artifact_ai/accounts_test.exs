defmodule ArtifactAi.AccountsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.Accounts

  describe "users" do
    import ArtifactAi.AccountsFixtures

    test "upsert_user/1 creates a user" do
      valid_attrs = %{
        email: "email@example.org",
        image: "https://example.org/image",
        name: "some name",
        iss: "some issuer"
      }

      {:ok, user} = Accounts.upsert_user(:email, valid_attrs.email, valid_attrs)
      assert user.email == valid_attrs.email
      assert user.image == valid_attrs.image
      assert user.name == valid_attrs.name
    end

    test "upsert_user/1 returns an existing user" do
      fixture = user_fixture()
      {:ok, user} = Accounts.upsert_user(:email, fixture.email, fixture)
      assert user == fixture
    end
  end

  describe "addresses" do
    import ArtifactAi.AccountsFixtures

    test "create_address/1 creates an address" do
      user = user_fixture()

      valid_attrs = %{
        address1: "some street address",
        address2: "some apartment number",
        city: "some apartment number",
        region: "some state name",
        postcode: "12345",
        country: "US"
      }

      {:ok, address} = Accounts.create_address(user, valid_attrs)
      assert address.address1 == valid_attrs.address1
      assert address.address2 == valid_attrs.address2
      assert address.city == valid_attrs.city
      assert address.region == valid_attrs.region
      assert address.postcode == valid_attrs.postcode
      assert address.country == valid_attrs.country
    end
  end
end
