defmodule ArtifactAi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :name, :string
      add :image, :string
      add :iss, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:tokens) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false

      timestamps(updated_at: false)
    end

    create index(:tokens, [:user_id])
    create unique_index(:tokens, [:context, :token])
  end
end
