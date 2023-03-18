defmodule ArtifactAi.Offers do
  @moduledoc false
  alias ArtifactAi.Repo
  alias ArtifactAi.Products.Offer

  alias ArtifactAi.Products.Sku

  ## Offers

  def create_offer(%Sku{} = sku, attrs) do
    Ecto.build_assoc(sku, :offers)
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end
end
