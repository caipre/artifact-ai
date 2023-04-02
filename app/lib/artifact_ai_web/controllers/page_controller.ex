defmodule ArtifactAiWeb.PageController do
  use ArtifactAiWeb, :controller

  def welcome(conn, _params) do
    google_client_id =
      Application.get_env(:artifact_ai, ArtifactAiWeb.Token, [])
      |> Keyword.fetch!(:google_client_id)

    conn
    |> assign(:google_client_id, google_client_id)
    |> assign(:login_uri, url(~p"/auth/sign_in"))
    |> render(:welcome, layout: false)
  end

  def about(conn, _params) do
    conn
    |> render(:about)
  end
end

defmodule ArtifactAiWeb.PageHTML do
  use ArtifactAiWeb, :html

  embed_templates "page_html/*"
end
