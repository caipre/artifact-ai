defmodule CanvasChamp.Behaviours.OrdersBehaviour do
  alias CanvasChamp.Orders.AdditionalInformation
  alias CanvasChamp.Orders.BillingAddress
  alias CanvasChamp.Orders.Customer
  alias CanvasChamp.Orders.Error
  alias CanvasChamp.Orders.NewCustomer
  alias CanvasChamp.Orders.Product
  alias CanvasChamp.Orders.ShippingAddress

  @callback create(
              customer :: NewCustomer.t() | Customer.t(),
              products :: [Product.t()],
              shippingAddress :: ShippingAddress.t(),
              billingAddress :: BillingAddress.t(),
              additionalInformation :: AdditionalInformation.t()
            ) :: {:ok, String.t()} | {:error, Error.t()}
end
