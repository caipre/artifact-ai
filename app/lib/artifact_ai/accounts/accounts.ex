defmodule ArtifactAi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo
  alias Ecto.Multi

  alias ArtifactAi.Accounts.Auth
  alias ArtifactAi.Accounts.Session
  alias ArtifactAi.Accounts.User

  def create_user(attrs) do
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

  @doc """
  Get a user by email, creating if necessary.
  """
  def get_user_by_email(email, attrs \\ %{}) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil -> create_user(attrs)
      user -> {:ok, user}
    end
  end

  ## Session Tokens

  def create_session_token(account) do
    token = Session.build_session_token(account)
    Repo.insert!(token)
    token.token
  end

  def get_by_session_token(token) do
    {:ok, query} = Session.verify_session_token_query(token)
    Repo.one(query)
  end

  def delete_session_token(token) do
    query = from s in Session, where: s.token == ^token
    Repo.delete_all(query)
    :ok
  end
end
