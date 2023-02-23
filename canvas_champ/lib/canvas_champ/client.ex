defmodule CanvasChamp.HttpClient do
  @moduledoc false

  use Knigge,
    otp_app: :canvas_champ,
    default: CanvasChamp.HttpClientImpl

  @type methods :: :get | :post | :head | :patch | :delete | :options | :put | String.t()

  @callback request(
              method :: methods(),
              url :: String.t(),
              headers :: [{String.t(), String.t()}],
              params :: map() | nil
            ) :: {:ok, String.t()} | {:error, Exception.t()}
end

defmodule CanvasChamp.HttpClientImpl do
  #  Impl using Finch.
  @moduledoc false

  alias CanvasChamp.HttpClient

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
end

defmodule CanvasChamp.ApiClient do
  #  A small helper to manages urls, headers, and types.
  @moduledoc false

  alias CanvasChamp.Error
  alias CanvasChamp.HttpClient

  @base_url "https://api.canvaschamp.com"
  @version "V1"

  def request(method, resource, headers \\ [], body \\ %{}) do
    headers = merge_with_auth_header([{"content-type", "application/json"} | headers])

    case HttpClient.request(method, resource_url(resource), headers, body) do
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

  defp merge_with_auth_header(headers) do
    oauth_consumer_key = Application.get_env(:canvas_champ, :consumer_key)
    oauth_nonce = todo()
    oauth_signature_method = todo()
    oauth_signature = todo()
    oauth_timestamp = todo()
    oauth_token = todo()

    authorization =
      [
        oauth_consumer_key: oauth_consumer_key,
        oauth_nonce: oauth_nonce,
        oauth_signature_method: oauth_signature_method,
        oauth_signature: oauth_signature,
        oauth_timestamp: oauth_timestamp,
        oauth_token: oauth_token
      ]
      |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
      |> Enum.join(",")

    headers = [{"authorization", "OAuth #{authorization}"} | headers]
    headers
  end

  defp resource_url(resource), do: "#{@base_url}/rest/#{@version}/#{resource}"
  defp todo, do: "todo"
end
