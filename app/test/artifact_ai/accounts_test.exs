defmodule ArtifactAi.AccountsTest do
  use ArtifactAi.DataCase

  alias ArtifactAi.Accounts

  describe "users" do
    alias ArtifactAi.User

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "email@example.org",
        image: "some image",
        name: "some name",
        iss: "some iss"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "email@example.org"
      assert user.image == "some image"
      assert user.name == "some name"
      assert user.iss == "some iss"
    end
  end
end
