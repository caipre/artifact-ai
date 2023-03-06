defmodule ArtifactAi.Accounts.Token do
  use Ecto.Schema
  import Ecto.Query

  alias ArtifactAi.Accounts.Token
  alias ArtifactAi.Accounts.User

  @rand_size 64

  @session_validity_in_days 60

  schema "tokens" do
    field :token, :binary
    field :context, :string
    belongs_to :user, User, type: Ecto.UUID
    timestamps(updated_at: false)
  end

  def build_session_token(%User{} = user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    %Token{token: token, context: "session", user_id: user.id}
  end

  @doc """
  Return the token struct for the given token value and context.
  """
  def token_and_context_query(token, context) do
    from Token, where: [token: ^token, context: ^context]
  end

  @doc """
  Check if the token is valid and return its underlying lookup query.
  The query returns the user found by the token, if any.
  The token is valid if it matches the value in the database and it has
  not expired (after @session_validity_in_days).
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end
end
