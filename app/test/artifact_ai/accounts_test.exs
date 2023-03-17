defmodule ArtifactAi.AccountsTest do
  use ArtifactAi.DataCase, async: true

  alias ArtifactAi.Accounts

  describe "users" do
    test "register_user/1 with valid data creates a user, auth, and session" do
      valid_attrs = %{
        email: "email@example.org",
        image: "some image",
        name: "some name",
        iss: "some iss"
      }

      assert {:ok, %{user: user, auth: auth, session: session} = _multi} =
               Accounts.create_user(valid_attrs)

      assert user.email == "email@example.org"
      assert user.image == "some image"
      assert user.name == "some name"
      assert auth.iss == "some iss"
      assert is_binary(session.token)
    end
  end
end
