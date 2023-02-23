defmodule CanvasChamp.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CanvasChamp.Orders` context.
  """

  alias CanvasChamp.Orders.AdditionalInformation
  alias CanvasChamp.Orders.BillingAddress
  alias CanvasChamp.Orders.Customer
  alias CanvasChamp.Orders.NewCustomer
  alias CanvasChamp.Orders.Product
  alias CanvasChamp.Orders.ShippingAddress

  def new_customer_fixture(attrs \\ %{}) do
    %NewCustomer{
      email: "test@example.org",
      firstname: "firstname",
      lastname: "lastname",
      password: "password"
    }
    |> Kernel.struct(attrs)
  end

  def customer_fixture(attrs \\ %{}) do
    %Customer{
      email: "test@example.org"
    }
    |> Kernel.struct(attrs)
  end

  def product_fixture(attrs \\ %{}) do
    %Product{
      name: "product name",
      qty: 1,
      height: 2,
      width: 3,
      price: 12.34,
      comment: "comment",
      images: [%{"image name" => "https://example.org"}],
      options: [%{"Hardware" => "Easel Black"}]
    }
    |> Kernel.struct(attrs)
  end

  def billing_address_fixture(attrs \\ %{}) do
    %BillingAddress{
      firstname: "firstname",
      lastname: "lastname",
      region: "region",
      country_id: "US",
      street: ["123 Main Street"],
      postcode: "10577",
      city: "Albany",
      telephone: "000-555-2222",
      company: "company name"
    }
    |> Kernel.struct(attrs)
  end

  def shipping_address_fixture(attrs \\ %{}) do
    %ShippingAddress{
      firstname: "firstname",
      lastname: "lastname",
      region: "region",
      country_id: "US",
      street: ["123 Main Street"],
      postcode: "10577",
      city: "Albany",
      telephone: "000-555-2222",
      company: "company name"
    }
    |> Kernel.struct(attrs)
  end

  def additional_information_fixture(attrs \\ %{}) do
    %AdditionalInformation{
      reference_order_id: "12345",
      dropship: 1
    }
    |> Kernel.struct(attrs)
  end
end
