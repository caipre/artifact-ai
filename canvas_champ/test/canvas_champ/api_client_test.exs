defmodule CanvasChamp.ApiClientTest do
  use ExUnit.Case, async: true

  alias CanvasChamp.ApiClient

  import Hammox

  setup :verify_on_exit!

  describe "request/4" do
    test "decodes response as json" do
      HttpClientImplMock
      |> expect(:request, fn _, _, _, _ -> {:ok, Jason.encode!(%{foo: "bar"})} end)

      assert ApiClient.request(:post, "https://example.org") ==
               {:ok, %{"foo" => "bar"}}
    end
  end
end
