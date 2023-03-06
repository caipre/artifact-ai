defmodule ArtifactAiWeb.PageController do
  use ArtifactAiWeb, :controller

  def sign_in(conn, _params) do
    google_client_id =
      Application.get_env(:artifact_ai, ArtifactAiWeb.Token, [])
      |> Keyword.fetch!(:google_client_id)

    conn
    |> assign(:google_client_id, google_client_id)
    |> assign(:login_uri, url(~p"/auth/sign_in"))
    |> render(:sign_in, layout: false)
  end

  def welcome(conn, _params) do
    conn
    |> render(:welcome)
  end
end

defmodule ArtifactAiWeb.PageHTML do
  use ArtifactAiWeb, :html

  embed_templates "page_html/*"
end
