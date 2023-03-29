defmodule ArtifactAi.Accounts do
  @moduledoc false
  alias ArtifactAi.Repo
  alias Ecto.Multi
  import Ecto.Query

  alias ArtifactAi.Accounts.Auth
  alias ArtifactAi.Accounts.Session
  alias ArtifactAi.Accounts.User

  ## Accounts

  def get!(id) do
    Repo.get!(User, id)
  end

  def from!(shortid) do
    Repo.from!(User, shortid)
  end

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

  ## Addresses

  def create_address(%User{} = user, attrs) do
    Ecto.build_assoc(user, :addresses)
    |> Address.changeset(attrs)
  end

  ## Sessions

  def get_user_by_session_token(token) do
    {:ok, query} = Session.verify_session_token_query(token)
    Repo.one(query)
  end

  def create_session_token(account) do
    token = Session.build_session_token(account)
    Repo.insert!(token)
    token.token
  end

  def delete_session_token(token) do
    query = from s in Session, where: s.token == ^token
    Repo.delete_all(query)
    :ok
  end
end
