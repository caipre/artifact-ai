defmodule ArtifactAi.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :name, :string
      add :image, :text
      timestamps(default: fragment("now()"))
    end

    create table(:auth, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :iss, :string, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :binary
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :address1, :string, null: false
      add :address2, :string
      add :city, :string, null: false
      add :region, :string, null: false
      add :postcode, :string, null: false
      add :country, :string, size: 2, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:prompts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :prompt, :text, null: false
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :prompt_id, references(:prompts, type: :binary_id), null: false
      add :url, :text, null: false
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :price, :integer
      add :currency, :string, size: 3, null: false, default: "USD"
      timestamps(default: fragment("now()"))
    end

    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :amount_subtotal, :integer, null: false
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:order_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :prompt_id, references(:prompts, type: :binary_id), null: false
      add :image_id, references(:images, type: :binary_id), null: false
      add :quantity, :integer, null: false, default: 1
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:order_details, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :external_id, :string, null: false
      add :shipping_address_id, references(:addresses, type: :binary_id), null: false
      add :amount_shipping, :integer, null: false
      add :amount_tax, :integer, null: false
      add :amount_total, :integer, null: false
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:order_states, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :previous_id, references(:order_states, type: :binary_id)
      add :state, :string
      timestamps(default: fragment("now()"), updated_at: false)
    end
  end
end
