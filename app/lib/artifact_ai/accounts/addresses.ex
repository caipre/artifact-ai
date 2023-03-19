defmodule ArtifactAi.Addresses do
  @moduledoc false

  import Ecto.Query, warn: false
  alias ArtifactAi.Repo

  alias ArtifactAi.Accounts.Address
  alias ArtifactAi.Accounts.User

  def create(%User{} = user, attrs) do
    Ecto.build_assoc(user, :addresses)
    |> Address.changeset(attrs)
    |> Repo.insert()
  end
end
