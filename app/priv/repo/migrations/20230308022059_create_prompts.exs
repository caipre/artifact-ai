defmodule ArtifactAi.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false
      add :prompt, :text

      timestamps(updated_at: false)
    end

    create index(:prompts, [:user_id])
  end
end
