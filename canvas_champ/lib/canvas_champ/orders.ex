defmodule CanvasChamp.Orders do
  @moduledoc false
  use Box

  defbox(Error,
    message: String.t()
  )

  defbox(NewCustomer,
    email: String.t(),
    firstname: String.t(),
    lastname: String.t(),
    password: String.t()
  )

  defbox(Customer,
    email: String.t()
  )

  defbox(Product,
    name: String.t(),
    qty: integer(),
    height: integer(),
    width: integer(),
    price: float(),
    comment: String.t(),
    images: [%{String.t() => String.t()}],
    options: [%{String.t() => String.t()}]
  )

  defbox(BillingAddress,
    firstname: String.t(),
    lastname: String.t(),
    region: String.t(),
    country_id: String.t(),
    street: [String.t()],
    postcode: String.t(),
    city: String.t(),
    telephone: String.t(),
    company: String.t()
  )

  defbox(ShippingAddress,
    firstname: String.t(),
    lastname: String.t(),
    region: String.t(),
    country_id: String.t(),
    street: [String.t()],
    postcode: String.t(),
    city: String.t(),
    telephone: String.t(),
    company: String.t()
  )

  defbox(AdditionalInformation,
    reference_order_id: String.t(),
    dropship: integer()
  )
end
