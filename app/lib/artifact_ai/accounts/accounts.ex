defmodule ArtifactAi.Accounts do
  @moduledoc false

  alias ArtifactAi.Repo
  alias Ecto.Multi

  alias ArtifactAi.Accounts.Auth
  alias ArtifactAi.Accounts.Session
  alias ArtifactAi.Accounts.User

  @spec upsert_user(:email, binary(), map()) :: {:ok, %User{}} | {:error, any()}
  def upsert_user(:email, email, attrs) do
    case Repo.get_by(User, email: email) do
      nil -> create_user(attrs)
      user -> {:ok, user}
    end
  end

  def create_user(attrs) do
    case create_user_multi(attrs) do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end

  defp create_user_multi(attrs) do
    Multi.new()
    |> Multi.insert(:user, %User{} |> User.changeset(attrs))
    |> Multi.insert(:auth, fn %{user: user} ->
      Ecto.build_assoc(user, :auth)
      |> Auth.changeset(attrs)
    end)
    |> Multi.insert(:session, fn %{user: user} ->
      Session.build_session_token(user)
    end)
    |> Repo.transaction()
  end
end
