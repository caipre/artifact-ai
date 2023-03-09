defmodule CanvasChamp.HttpClient do
  @moduledoc false

  use Knigge,
    otp_app: :canvas_champ,
    default: CanvasChamp.ApiClient

  @type methods :: :get | :post | :head | :patch | :delete | :options | :put | String.t()

  @callback request(
              method :: methods(),
              url :: String.t(),
              headers :: [{String.t(), String.t()}],
              params :: map() | nil
            ) :: {:ok, String.t()} | {:error, Exception.t()}
end

defmodule CanvasChamp.ApiClient do
  @moduledoc false

  alias CanvasChamp.Error
  alias CanvasChamp.HttpClient

  @base_url "https://api.canvaschamp.com"
  @version "V1"

  @oauth_version "1.0"
  @oauth_signature_method "HMAC-SHA1"
  @oauth_nonce_size 4

  def post(resource, body \\ %{}, headers \\ []) do
    url = resource_url(resource)

    headers =
      merge_with_auth_header("POST", url, [{"content-type", "application/json"} | headers])

    case HttpClient.request(:post, url, headers, body) do
      {:ok, json} -> decode(json)
      {:error, ex} -> {:error, ex}
    end
  end

  defp decode(body) do
    case Jason.decode!(body) do
      %{"message" => message} ->
        {:error, %Error{message: message}}

      body ->
        {:ok, body}
    end
  end

  @behaviour HttpClient

  @impl HttpClient
  def request(method, url, headers, params) do
    finch_request(method, url, headers, params)
    |> case do
      {:ok, %Finch.Response{status: 200, body: body}} -> {:ok, body}
      {:ok, %Finch.Response{status: code, body: body}} -> {:error, {:http, code, body}}
      {:error, ex} -> {:error, ex}
    end
  end

  defp finch_request(method, url, headers, %{}) do
    Finch.build(method, url, headers)
    |> Finch.request(CanvasChamp.Finch)
  end

  defp finch_request(method, url, headers, params) do
    Finch.build(method, url, headers, Jason.encode!(params))
    |> Finch.request(CanvasChamp.Finch)
  end

  def merge_with_auth_header(http_method, url, headers \\ []) do
    [
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      access_token: access_token,
      access_token_secret: access_token_secret
    ] = Application.get_env(:canvas_champ, __MODULE__, [])

    oauth_timestamp =
      DateTime.utc_now()
      |> DateTime.to_unix()
      |> Integer.to_string()

    oauth_nonce =
      :crypto.strong_rand_bytes(@oauth_nonce_size)
      |> Base.encode16()
      |> String.downcase()

    header =
      build_auth_header(
        http_method,
        url,
        oauth_nonce,
        oauth_timestamp,
        consumer_key,
        consumer_secret,
        access_token,
        access_token_secret
      )

    [header | headers]
  end

  def build_auth_header(
        http_method,
        url,
        oauth_nonce,
        oauth_timestamp,
        oauth_consumer_key,
        oauth_consumer_secret,
        oauth_token,
        oauth_token_secret
      ) do
    signing_key = "#{oauth_consumer_secret}&#{oauth_token_secret}}"

    message =
      [
        http_method,
        url,
        oauth_nonce,
        @oauth_signature_method,
        oauth_timestamp,
        @oauth_version,
        oauth_consumer_key,
        oauth_token
      ]
      |> Enum.map(&Base.url_encode64/1)
      |> Enum.join("&")

    oauth_signature =
      :crypto.mac(:hmac, :sha, signing_key, message)
      |> Base.url_encode64()

    authorization =
      [
        oauth_consumer_key: oauth_consumer_key,
        oauth_nonce: oauth_nonce,
        oauth_signature_method: @oauth_signature_method,
        oauth_signature: oauth_signature,
        oauth_timestamp: oauth_timestamp,
        oauth_token: oauth_token
      ]
      |> Enum.map(fn {k, v} -> "#{k}='#{v}'" end)
      |> Enum.join(",")

    {"authorization", "OAuth #{authorization}"}
  end

  defp resource_url(resource), do: "#{@base_url}/rest/#{@version}/#{resource}"
end
