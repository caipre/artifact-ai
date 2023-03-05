defmodule ArtifactAiWeb.Token do
  use Joken.Config, default_signer: nil

  add_hook(JokenJwks, strategy: ArtifactAiWeb.Jwks.GoogleId)

  @impl true
  def token_config do
    aud =
      Application.get_env(:artifact_ai, __MODULE__, [])
      |> Keyword.fetch!(:google_client_id)

    default_claims(skip: [:aud, :iss])
    |> add_claim("roles", nil, &(&1 in ["admin", "user"]))
    |> add_claim("aud", nil, &(&1 == aud))
    |> add_claim("iss", nil, &(&1 in ["accounts.google.com", "https://accounts.google.com"]))
  end
end

defmodule ArtifactAiWeb.Jwks.GoogleId do
  @moduledoc """
  Verification of a Google ID.
  Refer to https://developers.google.com/identity/gsi/web/guides/verify-google-id-token
  """

  use JokenJwks.DefaultStrategyTemplate

  def init_opts(opts) do
    Keyword.merge(opts, jwks_url: "https://www.googleapis.com/oauth2/v3/certs")
  end

  @spec verify_csrf_token(map(), map()) :: {:ok, String.t()} | {:error, atom()}
  def verify_csrf_token(
        %{"g_csrf_token" => csrf_token_cookie} = _cookies,
        %{"g_csrf_token" => csrf_token_body} = _params
      ) do
    if csrf_token_cookie == csrf_token_body do
      {:ok, csrf_token_body}
    else
      {:error, :invalid}
    end
  end

  def verify_csrf_token(_cookies, _body) do
    {:error, :missing}
  end
end
