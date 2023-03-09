defmodule ArtifactAi.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false

      add :prompt, :text, null: false

      timestamps(updated_at: false)
    end

    create index(:prompts, [:user_id])

    create table(:images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false
      add :prompt_id, references(:prompts, on_delete: :nothing), null: false

      add :url, :text, null: false

      timestamps(updated_at: false)
    end

    create index(:images, [:user_id])
    create index(:images, [:prompt_id])
  end
end
