defmodule ArtifactAi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo

  alias ArtifactAi.Token
  alias ArtifactAi.User

  @doc """
  Create a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Get a user by email, creating if necessary.
  """
  def get_by_email(email, attrs \\ %{}) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil -> create_user(attrs)
      user -> {:ok, user}
    end
  end

  ## Session Tokens

  def create_session_token(account) do
    token = Token.build_session_token(account)
    Repo.insert!(token)
    token.token
  end

  def get_by_session_token(token) do
    {:ok, query} = Token.verify_session_token_query(token)
    Repo.one(query)
  end

  def delete_session_token(token) do
    Repo.delete_all(Token.token_and_context_query(token, "session"))
    :ok
  end
end
