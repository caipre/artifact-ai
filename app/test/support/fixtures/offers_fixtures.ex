defmodule ArtifactAi.OffersFixtures do
  @moduledoc false

  alias ArtifactAi.Offers

  def offer_fixture(sku, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        price: "12.34",
        currency: "USD",
        expires_at: DateTime.utc_now() |> DateTime.add(1, :day) |> DateTime.truncate(:second)
      })

    {:ok, offer} = Offers.create_offer(sku, attrs)
    offer
  end
end
