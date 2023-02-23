defmodule CanvasChamp.OrdersImplTest do
  use ExUnit.Case, async: true

  import CanvasChamp.OrdersFixtures

  alias CanvasChamp.Orders

  import Hammox

  doctest Orders

  setup :verify_on_exit!

  describe "create/5" do
    test "with valid data creates an order" do
      expect(HttpClientImplMock, :request, fn _, _, _, _ ->
        {:ok, Jason.encode!("USA158867018117")}
      end)

      assert {:ok, _} =
               Orders.create(
                 new_customer_fixture(),
                 [product_fixture()],
                 shipping_address_fixture(),
                 billing_address_fixture(),
                 additional_information_fixture()
               )
    end

    test "with invalid data returns an error" do
      expect(HttpClientImplMock, :request, fn _, _, _, _ ->
        {:ok,
         Jason.encode!(%{
           message: "Customer Validation Error(s): \"email\" is required. Enter and try again."
         })}
      end)

      assert {:error, _} =
               Orders.create(
                 new_customer_fixture(%{email: ""}),
                 [product_fixture()],
                 shipping_address_fixture(),
                 billing_address_fixture(),
                 additional_information_fixture()
               )
    end
  end
end
