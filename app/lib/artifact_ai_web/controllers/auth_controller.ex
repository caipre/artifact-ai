defmodule ArtifactAiWeb.AuthController do
  use ArtifactAiWeb, :controller

  alias ArtifactAiWeb.Token
  alias ArtifactAiWeb.Jwks.GoogleId

  def maybe_sign_in(conn, %{"credential" => credential} = params) do
    fetch_cookies(conn)

    with {:ok, _csrf_token} <- GoogleId.verify_csrf_token(conn.cookies, params),
         {:ok, jwt} <- Token.verify_and_validate(credential) do
      sign_in(conn)
    else
      {:error, reason} ->
        redirect_to_sign_in(conn, "Authentication failed: #{reason}")
    end
  end

  ## Helpers

  @doc """
  Sign an account in.
  The session is renewed and cleared to avoid fixation attacks.
  """
  defp sign_in(conn) do
    token = "todo: generate session token for user"

    return_to = get_session(conn, :return_to)

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_token_in_session(token)
    |> redirect(to: return_to || signed_in_path(conn))
  end

  @doc """
  Sign an account out.
  The session is dropped and cleared to avoid leaking session contents.
  """
  defp sign_out(conn) do
    token = get_session(conn, :token)
    #    token && Accounts.delete_session_token(token)
    if live_socket_id = get_session(conn, :live_socket_id) do
      ArtifactAiWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> configure_session(drop: true)
    |> clear_session()
    |> redirect(to: sign_in_path(conn))
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:token, token)
    |> put_session(:live_socket_id, "s:#{Base.url_encode64(token)}")
  end

  ## Plugs

  @doc """
  Checks whether there is a current_user in the session.
  Redirects to the sign in page if not.
  """
  def authenticated(conn, _opts) do
    unless conn.assigns[:current_user],
      do: redirect_to_sign_in(conn, "You must be signed in to access that page.")

    conn
  end

  def assign_current_user(conn, _opts) do
  end

  ## Plug helpers

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

  defp sign_in_path(_conn), do: ~p"/"
  defp signed_in_path(_conn), do: ~p"/create"
end

defmodule ArtifactAiWeb.AuthHTML do
  use ArtifactAiWeb, :html

  embed_templates "auth_html/*"
end
