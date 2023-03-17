defmodule ArtifactAi.Accounts.Auth do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "auth" do
    belongs_to :user, User, type: Ecto.UUID
    field :iss, :string

    timestamps()
  end

  @doc false
  def changeset(auth, attrs) do
    auth
    |> cast(attrs, [:iss])
    |> validate_required([:iss])
  end
end
