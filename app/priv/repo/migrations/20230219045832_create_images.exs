defmodule ArtifactAi.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :url, :text
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :prompt_id, references(:prompts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:images, [:user_id])
    create index(:images, [:prompt_id])
  end
end
