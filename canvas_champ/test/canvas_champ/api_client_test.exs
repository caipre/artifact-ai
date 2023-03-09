defmodule CanvasChamp.ApiClientTest do
  use ExUnit.Case, async: true

  alias CanvasChamp.ApiClient

  import Hammox

  setup :verify_on_exit!

  describe "ApiClient" do
    test "build_auth_header/8" do
      {header, value} =
        ApiClient.build_auth_header(
          "POST",
          "https://example.org",
          "nonce",
          "1588670178",
          "your_consumer_key",
          "your_consumer_secret",
          "your_access_token",
          "your_access_token_secret"
        )

      assert header == "authorization"

      assert value ==
               [
                 "OAuth oauth_consumer_key='your_consumer_key'",
                 "oauth_nonce='nonce'",
                 "oauth_signature_method='HMAC-SHA1'",
                 "oauth_signature='jcd9SSoiqqckxxo_5sEQ2XyWZkk='",
                 "oauth_timestamp='1588670178'",
                 "oauth_token='your_access_token'"
               ]
               |> Enum.join(",")
    end
  end

  describe "request/4" do
    test "decodes response as json" do
      HttpClientMock
      |> expect(:request, fn _, _, _, _ -> {:ok, Jason.encode!(%{foo: "bar"})} end)

      assert ApiClient.post("https://example.org") == {:ok, %{"foo" => "bar"}}
    end
  end
end
