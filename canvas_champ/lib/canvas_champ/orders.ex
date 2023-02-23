defmodule CanvasChamp.Orders do
  @moduledoc "Provides the ability to interact with the CanvasChamp Orders API."

  use Box

  use Knigge,
    otp_app: :canvas_champ,
    default: CanvasChamp.OrdersImpl

  alias CanvasChamp.Error

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

  @callback create(
              customer :: NewCustomer.t() | Customer.t(),
              products :: [Product.t()],
              shippingAddress :: ShippingAddress.t(),
              billingAddress :: BillingAddress.t(),
              additionalInformation :: AdditionalInformation.t()
            ) :: {:ok, String.t()} | {:error, Error.t()}
end

defmodule CanvasChamp.OrdersImpl do
  @moduledoc false

  alias CanvasChamp.ApiClient
  alias CanvasChamp.Orders

  @behaviour Orders

  @impl Orders
  def create(customer, products, shippingAddress, billingAddress, additionalInformation) do
    ApiClient.request(:post, "cporders/create", [], %{
      customer: customer,
      products: products,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      additionalInformation: additionalInformation
    })
  end
end
