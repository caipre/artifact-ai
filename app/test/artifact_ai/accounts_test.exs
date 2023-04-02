defmodule ArtifactAi.AccountsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.AccountsFixtures

  alias ArtifactAi.Accounts

  describe "accounts" do
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
      fixture = AccountsFixtures.user_fixture()
      {:ok, user} = Accounts.upsert_user(:email, fixture.email, fixture)
      assert user == fixture
    end
  end
end
