defmodule ArtifactAiWeb.Plugs.Auth do
  use ArtifactAiWeb, :controller

  alias ArtifactAi.Accounts

  ## conn

  @doc """
  Checks whether there is a current_user in the session.
  Redirects to the sign in page if not.
  """
  def authenticated(conn, _opts) do
    unless conn.assigns[:current_user],
      do: redirect_to_sign_in(conn, "You must be signed in to access that page.")

    conn
  end

  @doc """
  Assigns @current_user to conn assigns for the session token.
  If the session token is missing or expired, @current_user will be nil.
  """
  def assign_current_user(conn, _opts) do
    token = get_session(conn, :token)
    user = token && Accounts.get_user_by_session_token(token)
    assign(conn, :current_user, user)
  end

  ## socket

  @doc """
  Assigns @current_user to socket assigns for the session token.
  If the session token is missing or expired, @current_user will be nil.
  """
  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(session, socket)}
  end

  def mount_current_user(session, socket) do
    case session do
      %{"token" => token} ->
        Phoenix.Component.assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(token)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :current_user, fn -> nil end)
    end
  end

  ## helpers

  defp redirect_to_sign_in(conn, message) do
    conn
    |> put_flash(:error, message)
    |> maybe_store_return_to()
    |> redirect(to: sign_in_path(conn))
    |> halt()
  end

  defp maybe_store_return_to(%{method: "GET"} = conn),
    do: put_session(conn, :return_to, current_path(conn))

  defp maybe_store_return_to(conn), do: conn

  defp sign_in_path(_conn), do: ~p"/welcome"
end
