defmodule ArtifactAi.Accounts.Session do
  use Ecto.Schema
  import Ecto.Query

  alias ArtifactAi.Accounts.Session
  alias ArtifactAi.Accounts.User

  @rand_size 64

  @session_validity_in_days 60

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "sessions" do
    belongs_to :user, User, type: Ecto.UUID
    field :token, :binary

    timestamps(updated_at: false)
  end

  def build_session_token(%User{} = user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    %Session{token: token, user_id: user.id}
  end

  @doc """
  Check if the token is valid and return its underlying lookup query.
  The query returns the user found by the token, if any.
  The token is valid if it matches the value in the database and has
  not expired (after @session_validity_in_days).
  """
  def verify_session_token_query(token) do
    query =
      from session in Session,
        join: user in assoc(session, :user),
        where: session.token == ^token,
        where: session.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end
end
