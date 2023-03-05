defmodule ArtifactAiWeb.PageController do
  use ArtifactAiWeb, :controller

  alias ArtifactAiWeb.Token
  alias ArtifactAiWeb.Jwks.GoogleId

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def show_login(conn, _params) do
    google_client_id =
      Application.get_env(:artifact_ai, ArtifactAiWeb.Token, [])
      |> Keyword.fetch!(:google_client_id)

    conn
    |> assign(:google_client_id, google_client_id)
    |> assign(:login_uri, url(~p"/login"))
    |> render(:login, layout: false)
  end

  def handle_login(conn, %{"credential" => credential} = params) do
    fetch_cookies(conn)

    with {:ok, _csrf_token} <- GoogleId.verify_csrf_token(conn.cookies, params),
         {:ok, jwt} <- Token.verify_and_validate(credential) do
      %{"name" => name} = jwt

      conn
      |> put_flash(:info, "Welcome #{name}")
      |> assign(:jwt, Jason.encode!(jwt, pretty: true))
      |> render(:jwt)
    else
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error")
        |> redirect(to: ~p"/")
    end
  end
end
