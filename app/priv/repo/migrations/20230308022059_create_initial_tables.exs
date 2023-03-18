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
      add :price, :decimal
      add :currency, :string, size: 3, null: false, default: "USD"
      timestamps(default: fragment("now()"))
    end

    create table(:product_attributes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, references(:products, type: :binary_id), null: false
      add :name, :text, null: false
      add :value, :text, null: false
      add :price, :decimal
      add :currency, :string, size: 3, null: false, default: "USD"
      timestamps(default: fragment("now()"))
    end

    create table(:product_parameters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, references(:products, type: :binary_id), null: false
      add :name, :text, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:skus, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, references(:products, type: :binary_id), null: false
      timestamps(default: fragment("now()"))
    end

    create table(:sku_product_attributes, primary_key: false) do
      add :sku_id, references(:skus, type: :binary_id), null: false
      add :product_attribute_id, references(:product_attributes, type: :binary_id), null: false
      timestamps(default: fragment("now()"), updated_at: false)
    end

    create table(:offers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sku_id, references(:skus, type: :binary_id), null: false
      add :price, :decimal, null: false
      add :currency, :string, size: 3, null: false
      add :expires_at, :utc_datetime, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:carts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      timestamps(default: fragment("now()"))
    end

    create table(:cart_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cart_id, references(:carts, type: :binary_id), null: false
      add :offer_id, references(:offers, type: :binary_id), null: false
      add :prompt_id, references(:prompts, type: :binary_id), null: false
      add :quantity, :integer, null: false, default: 1
      timestamps(default: fragment("now()"))
    end

    create table(:cart_item_product_parameters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cart_item_id, references(:cart_items, type: :binary_id), null: false
      add :product_parameter_id, references(:product_parameters, type: :binary_id), null: false
      add :value, :binary_id, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: false
      add :cart_id, references(:carts, type: :binary_id), null: false
      add :subtotal, :decimal, null: false
    end

    create table(:order_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :offer_id, references(:offers, type: :binary_id), null: false
      add :prompt_id, references(:prompts, type: :binary_id), null: false
      add :quantity, :integer, null: false, default: 1
      timestamps(default: fragment("now()"))
    end

    create table(:order_item_product_parameters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_item_id, references(:cart_items, type: :binary_id), null: false
      add :product_parameter_id, references(:product_parameters, type: :binary_id), null: false
      add :value, :text, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:order_details, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :external_id, :string, null: false
      add :shipping_address_id, references(:addresses, type: :binary_id), null: false
      add :shipping, :decimal, null: false
      add :tax, :decimal, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :amount, :decimal, null: false
      add :currency, :string, size: 3, null: false
      add :external_id, :string, null: false
      timestamps(default: fragment("now()"))
    end

    create table(:order_states, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, type: :binary_id), null: false
      add :previous_id, references(:order_states, type: :binary_id), null: false
      add :state, :string
      timestamps(default: fragment("now()"))
    end
  end
end
